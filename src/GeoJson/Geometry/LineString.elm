module GeoJson.Geometry.LineString (LineString, getPositions, fromPositions, encode, decode) where

import GeoJson.Geometry.Position as Position exposing (Position)
import Json.Decode as Decode exposing ((:=))
import Json.Encode as Encode


type LineString
  = LS (List Position)


getPositions : LineString -> List Position
getPositions lineString =
  case lineString of
    LS positions ->
      positions


fromPositions : List Position -> LineString
fromPositions positions =
  LS positions


encode : LineString -> Encode.Value
encode lineString =
  Encode.object
    [ ( "type", Encode.string "LineString" )
    , ( "coordinates"
      , Encode.list
          <| List.map Position.encode (getPositions lineString)
      )
    ]


decode : Decode.Decoder LineString
decode =
  Decode.object1 LS ("coordinates" := Decode.list Position.decode)
