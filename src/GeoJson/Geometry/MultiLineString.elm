module GeoJson.Geometry.MultiLineString (MultiLineString, fromPositionsList, encode, decode) where

import GeoJson.Geometry.Position as Position exposing (Position)
import Json.Decode as Decode exposing ((:=))
import Json.Encode as Encode


type MultiLineString
  = MLS (List (List Position))


getPositions : MultiLineString -> List (List Position)
getPositions multiLineString =
  case multiLineString of
    MLS positionsList ->
      positionsList


fromPositionsList : List (List Position) -> MultiLineString
fromPositionsList =
  MLS


encode : MultiLineString -> Encode.Value
encode multiLineString =
  Encode.object
    [ ( "type", Encode.string "MultiLineString" )
    , ( "coordinates", encodeCoordinates (getPositions multiLineString) )
    ]


encodeCoordinates : List (List Position) -> Encode.Value
encodeCoordinates coordinates =
  Encode.list (List.map Position.encodeList coordinates)


decode : Decode.Decoder MultiLineString
decode =
  Decode.object1
    MLS
    ("coordinates" := Decode.list (Decode.list Position.decode))
