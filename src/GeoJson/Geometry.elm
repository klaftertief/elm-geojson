module GeoJson.Geometry (Geometry, point, multiPoint, lineString, multiLineString, polygon, multiPolygon, collection, noGeometry, split, encode, decode) where

import GeoJson.Geometry.LineString as LineString exposing (LineString)
import GeoJson.Geometry.MultiLineString as MultiLineString exposing (MultiLineString)
import GeoJson.Geometry.MultiPoint as MultiPoint exposing (MultiPoint)
import GeoJson.Geometry.MultiPolygon as MultiPolygon exposing (MultiPolygon)
import GeoJson.Geometry.Point as Point exposing (Point)
import GeoJson.Geometry.Polygon as Polygon exposing (Polygon)
import GeoJson.Geometry.Position as Position exposing (Position)
import Json.Decode as Decode exposing ((:=))
import Json.Encode as Encode


type Geometry
  = Point Point
  | MultiPoint MultiPoint
  | LineString LineString
  | MultiLineString MultiLineString
  | Polygon Polygon
  | MultiPolygon MultiPolygon
  | Collection (List Geometry)
  | NoGeometry


point : List Float -> Geometry
point =
  Point << Point.fromList


multiPoint : List (List Float) -> Geometry
multiPoint =
  MultiPoint << MultiPoint.fromPositions << List.map Position.fromList


lineString : List (List Float) -> Geometry
lineString =
  LineString << LineString.fromPositions << List.map Position.fromList


multiLineString : List (List (List Float)) -> Geometry
multiLineString =
  MultiLineString << MultiLineString.fromPositionsList << List.map (\list -> List.map Position.fromList list)


polygon : List (List (List Float)) -> Geometry
polygon =
  Polygon << Polygon.fromPositionsList << List.map (List.map Position.fromList)


multiPolygon : List (List (List (List Float))) -> Geometry
multiPolygon =
  MultiPolygon << MultiPolygon.fromPositionsList << List.map (List.map (List.map Position.fromList))


collection : List Geometry -> Geometry
collection =
  Collection


noGeometry : Geometry
noGeometry =
  NoGeometry


split : Geometry -> List Geometry
split geometry =
  case geometry of
    Collection geometries ->
      geometries

    _ ->
      [ geometry ]


encode : Geometry -> Encode.Value
encode geometry =
  case geometry of
    Point point ->
      Point.encode point

    MultiPoint multiPoint ->
      MultiPoint.encode multiPoint

    LineString lineString ->
      LineString.encode lineString

    MultiLineString multiLineString ->
      MultiLineString.encode multiLineString

    Polygon polygon ->
      Polygon.encode polygon

    MultiPolygon multiPolygon ->
      MultiPolygon.encode multiPolygon

    Collection geometries ->
      Encode.object
        [ ( "type", Encode.string "GeometryCollection" )
        , ( "geometries"
          , Encode.list (List.map encode geometries)
          )
        ]

    NoGeometry ->
      Encode.null


decode : Decode.Decoder Geometry
decode =
  ("type" := Decode.string)
    |> (flip Decode.andThen) decodeType


decodeType : String -> Decode.Decoder Geometry
decodeType tipe =
  case tipe of
    "Point" ->
      Decode.object1
        Point
        Point.decode

    "MultiPoint" ->
      Decode.object1
        MultiPoint
        MultiPoint.decode

    "LineString" ->
      Decode.object1
        LineString
        LineString.decode

    "MultiLineString" ->
      Decode.object1
        MultiLineString
        MultiLineString.decode

    "Polygon" ->
      Decode.object1
        Polygon
        Polygon.decode

    "MultiPolygon" ->
      Decode.object1
        MultiPolygon
        MultiPolygon.decode

    "GeometryCollection" ->
      Decode.object1
        Collection
        ("geometries" := Decode.list decode)

    _ ->
      Decode.fail ("Geometry type '" ++ tipe ++ "' not supported.")
