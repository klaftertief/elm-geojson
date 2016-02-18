module GeoJson.Geometry.Point (Point, getPosition, fromLonLat, fromLonLatAlt, fromEastingNorthing, fromEastingNorthingAlt, fromPosition, encode, decode) where

import GeoJson.Geometry.Position as Position exposing (Position)
import Json.Decode as Decode exposing ((:=))
import Json.Encode as Encode


type Point
  = P Position


getPosition : Point -> Position
getPosition point =
  case point of
    P position ->
      position


fromLonLat : Float -> Float -> Point
fromLonLat lon lat =
  P (Position.fromLonLat lon lat)


fromLonLatAlt : Float -> Float -> Float -> Point
fromLonLatAlt lon lat alt =
  P (Position.fromLonLatAlt lon lat alt)


fromEastingNorthing : Float -> Float -> Point
fromEastingNorthing easting northing =
  P (Position.fromEastingNorthing easting northing)


fromEastingNorthingAlt : Float -> Float -> Float -> Point
fromEastingNorthingAlt easting northing alt =
  P (Position.fromEastingNorthingAlt easting northing alt)


fromPosition : Position -> Point
fromPosition position =
  P position


encode : Point -> Encode.Value
encode point =
  Encode.object
    [ ( "type", Encode.string "Point" )
    , ( "coordinates", Position.encode (getPosition point) )
    ]


decode : Decode.Decoder Point
decode =
  Decode.object1 P ("coordinates" := Position.decode)
