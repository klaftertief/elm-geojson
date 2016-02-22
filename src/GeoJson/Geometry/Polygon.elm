module GeoJson.Geometry.Polygon (Polygon, fromPositionsList, encode, encodeCoordinates, decode) where

import GeoJson.Geometry.Position as Position exposing (Position)
import Json.Decode as Decode exposing ((:=))
import Json.Encode as Encode


type Polygon
  = P (List LinearRing)


type alias LinearRing =
  List Position



-- TODO: add factory and validations for LinearRing


getPositions : Polygon -> List (List Position)
getPositions polygon =
  case polygon of
    P positionsList ->
      positionsList


fromPositionsList : List (List Position) -> Polygon
fromPositionsList =
  P


encode : Polygon -> Encode.Value
encode polygon =
  Encode.object
    [ ( "type", Encode.string "Polygon" )
    , ( "coordinates", encodeCoordinates (getPositions polygon) )
    ]


encodeCoordinates : List (List Position) -> Encode.Value
encodeCoordinates coordinates =
  Encode.list (List.map Position.encodeList coordinates)


decode : Decode.Decoder Polygon
decode =
  Decode.object1
    P
    ("coordinates" := Decode.list (Decode.list Position.decode))
