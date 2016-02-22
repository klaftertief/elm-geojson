module GeoJson.Simple (GeoJson, point, multiPoint, lineString, multiLineString, polygon, multiPolygon, geometryCollection, feature, featureCollection, getGeometry, getFeature, encode, decode) where

{-| GeoJSON utilities for Elm.

# Types

@docs GeoJson, point, multiPoint, lineString, multiLineString, polygon, multiPolygon, geometryCollection, feature, featureCollection, getGeometry, getFeature, encode, decode

-}

import GeoJson.Geometry as Geometry
import GeoJson.Feature.Simple as Feature
import Json.Decode as Decode exposing ((:=))
import Json.Encode as Encode


{-| GeoJson
-}
type GeoJson
  = Geometry Geometry.Geometry
  | Feature Feature.Feature


{-|
-}
point : List Float -> GeoJson
point =
  Geometry << Geometry.point


{-|
-}
multiPoint : List (List Float) -> GeoJson
multiPoint =
  Geometry << Geometry.multiPoint


{-|
-}
lineString : List (List Float) -> GeoJson
lineString =
  Geometry << Geometry.lineString


{-|
-}
multiLineString : List (List (List Float)) -> GeoJson
multiLineString =
  Geometry << Geometry.multiLineString


{-|
-}
polygon : List (List (List Float)) -> GeoJson
polygon =
  Geometry << Geometry.polygon


{-|
-}
multiPolygon : List (List (List (List Float))) -> GeoJson
multiPolygon =
  Geometry << Geometry.multiPolygon


{-|
-}
geometryCollection : List Geometry.Geometry -> GeoJson
geometryCollection =
  Geometry << Geometry.collection


{-|
-}
feature : Geometry.Geometry -> GeoJson
feature =
  Feature << Feature.feature


{-|
-}
featureCollection : List Feature.Feature -> GeoJson
featureCollection =
  Feature << Feature.collection


{-|
-}
getGeometry : GeoJson -> Geometry.Geometry
getGeometry geoJson =
  case geoJson of
    Geometry geometry ->
      geometry

    Feature _ ->
      Geometry.noGeometry


{-|
-}
getFeature : GeoJson -> Feature.Feature
getFeature geoJson =
  case geoJson of
    Geometry _ ->
      Feature.noFeature

    Feature feature ->
      feature


{-|
-}
encode : GeoJson -> Encode.Value
encode geoJson =
  case geoJson of
    Geometry geometry ->
      Geometry.encode geometry

    Feature feature ->
      Feature.encode feature


{-|
-}
decode : Decode.Decoder GeoJson
decode =
  ("type" := Decode.string)
    |> (flip Decode.andThen) decodeType


decodeType : String -> Decode.Decoder GeoJson
decodeType tipe =
  case tipe of
    "Feature" ->
      Decode.object1 Feature Feature.decode

    "FeatureCollection" ->
      Decode.object1 Feature Feature.decode

    _ ->
      Decode.object1 Geometry Geometry.decode
