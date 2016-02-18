module GeoJson.Geometry.MultiPoint (MultiPoint, getPositions, fromPositions, encode, decode) where

import GeoJson.Geometry.Point as Point exposing (Point)
import GeoJson.Geometry.Position as Position exposing (Position)
import Json.Decode as Decode exposing ((:=))
import Json.Encode as Encode


type MultiPoint
  = MP (List Position)


getPositions : MultiPoint -> List Position
getPositions multiPoint =
  case multiPoint of
    MP positions ->
      positions


fromPositions : List Position -> MultiPoint
fromPositions positions =
  MP positions


merge : List Point -> MultiPoint
merge points =
  fromPositions (List.map Point.getPosition points)


split : MultiPoint -> List Point
split multiPoint =
  List.map Point.fromPosition (getPositions multiPoint)


encode : MultiPoint -> Encode.Value
encode multiPoint =
  Encode.object
    [ ( "type", Encode.string "MultiPoint" )
    , ( "coordinates"
      , Encode.list <| List.map Position.encode (getPositions multiPoint)
      )
    ]


decode : Decode.Decoder MultiPoint
decode =
  Decode.object1 MP ("coordinates" := Decode.list Position.decode)
