module GeoJson.Geometry.MultiPolygon (MultiPolygon, encode, decode) where

import GeoJson.Geometry.Polygon as Polygon
import GeoJson.Geometry.Position as Position exposing (Position)
import Json.Decode as Decode exposing ((:=))
import Json.Encode as Encode


type MultiPolygon
  = MP (List (List (List Position)))


getPositions : MultiPolygon -> List (List (List Position))
getPositions multiPolygon =
  case multiPolygon of
    MP positions ->
      positions


encode : MultiPolygon -> Encode.Value
encode multiPolygon =
  Encode.object
    [ ( "type", Encode.string "MultiPolygon" )
    , ( "coordinates"
      , Encode.list
          <| List.map Polygon.encodeCoordinates (getPositions multiPolygon)
      )
    ]


decode : Decode.Decoder MultiPolygon
decode =
  Decode.object1
    MP
    ("coordinates" := Decode.list (Decode.list (Decode.list Position.decode)))
