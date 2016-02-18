module GeoJson.Geometry.MultiLineString (MultiLineString, encode, decode) where

import GeoJson.Geometry.Position as Position exposing (Position)
import Json.Decode as Decode exposing ((:=))
import Json.Encode as Encode


type MultiLineString
  = MLS (List (List Position))


getPositionsList : MultiLineString -> List (List Position)
getPositionsList multiLineString =
  case multiLineString of
    MLS positionsList ->
      positionsList


encode : MultiLineString -> Encode.Value
encode multiLineString =
  Encode.object
    [ ( "type", Encode.string "MultiLineString" )
    , ( "coordinates"
      , Encode.list
          <| List.map Position.encodeList (getPositionsList multiLineString)
      )
    ]


decode : Decode.Decoder MultiLineString
decode =
  Decode.object1
    MLS
    ("coordinates" := Decode.list (Decode.list Position.decode))
