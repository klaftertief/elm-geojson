module GeoJson (GeoJson, encode, decode, makePoint) where

{-| GeoJSON utilities for Elm.

# Types

@docs GeoJson, encode, decode, makePoint

-}

import GeoJson.Geometry as Geometry
import GeoJson.Feature as Feature
import Json.Decode as Decode exposing ((:=))
import Json.Encode as Encode


{-| GeoJson
-}
type GeoJson
  = Geometry Geometry.Geometry
  | Feature Feature.Feature


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


{-|
-}
makePoint : Float -> Float -> GeoJson
makePoint lon lat =
  Geometry (Geometry.makePoint lon lat)
