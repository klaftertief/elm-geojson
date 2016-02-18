module GeoJson.Geometry (Geometry, encode, decode, makePoint) where

import GeoJson.Geometry.LineString as LineString exposing (LineString)
import GeoJson.Geometry.MultiLineString as MultiLineString exposing (MultiLineString)
import GeoJson.Geometry.MultiPoint as MultiPoint exposing (MultiPoint)
import GeoJson.Geometry.MultiPolygon as MultiPolygon exposing (MultiPolygon)
import GeoJson.Geometry.Point as Point exposing (Point)
import GeoJson.Geometry.Polygon as Polygon exposing (Polygon)
import Json.Decode as Decode exposing ((:=))
import Json.Encode as Encode


type Geometry
  = LineString LineString
  | MultiLineString MultiLineString
  | MultiPoint MultiPoint
  | MultiPolygon MultiPolygon
  | Point Point
  | Polygon Polygon
  | Collection (List Geometry)


makePoint : Float -> Float -> Geometry
makePoint lon lat =
  Point (Point.fromLonLat lon lat)


encode : Geometry -> Encode.Value
encode geometry =
  case geometry of
    LineString lineString ->
      LineString.encode lineString

    MultiLineString multiLineString ->
      MultiLineString.encode multiLineString

    MultiPoint multiPoint ->
      MultiPoint.encode multiPoint

    MultiPolygon multiPolygon ->
      MultiPolygon.encode multiPolygon

    Point point ->
      Point.encode point

    Polygon polygon ->
      Polygon.encode polygon

    Collection geometries ->
      Encode.object
        [ ( "type", Encode.string "GeometryCollection" )
        , ( "geometries"
          , Encode.list (List.map encode geometries)
          )
        ]


decode : Decode.Decoder Geometry
decode =
  ("type" := Decode.string)
    |> (flip Decode.andThen) decodeType


decodeType : String -> Decode.Decoder Geometry
decodeType tipe =
  case tipe of
    "LineString" ->
      Decode.object1
        LineString
        LineString.decode

    "MultiLineString" ->
      Decode.object1
        MultiLineString
        MultiLineString.decode

    "MultiPoint" ->
      Decode.object1
        MultiPoint
        MultiPoint.decode

    "MultiPolygon" ->
      Decode.object1
        MultiPolygon
        MultiPolygon.decode

    "Point" ->
      Decode.object1
        Point
        Point.decode

    "Polygon" ->
      Decode.object1
        Polygon
        Polygon.decode

    "GeometryCollection" ->
      Decode.object1
        Collection
        ("geometries" := Decode.list decode)

    _ ->
      Decode.fail ("Geometry type '" ++ tipe ++ "' not supported.")
