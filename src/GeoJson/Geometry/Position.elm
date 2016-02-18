module GeoJson.Geometry.Position (Position, fromLonLat, fromLonLatAlt, fromEastingNorthing, fromEastingNorthingAlt, encode, encodeList, decode) where

import Json.Decode as Decode
import Json.Encode as Encode


type alias Latitude =
  Float


type alias Longitude =
  Float


type alias Altitude =
  Float


type alias Easting =
  Float


type alias Northing =
  Float


type Position
  = LonLat Longitude Latitude
  | LonLatAlt Longitude Latitude Altitude
  | EastingNorthing Easting Northing
  | EastingNorthingAlt Easting Northing Altitude


fromLonLat : Float -> Float -> Position
fromLonLat lon lat =
  LonLat lon lat


fromLonLatAlt : Float -> Float -> Float -> Position
fromLonLatAlt lon lat alt =
  LonLatAlt lon lat alt


fromEastingNorthing : Float -> Float -> Position
fromEastingNorthing easting northing =
  EastingNorthing easting northing


fromEastingNorthingAlt : Float -> Float -> Float -> Position
fromEastingNorthingAlt easting northing alt =
  EastingNorthingAlt easting northing alt


encode : Position -> Encode.Value
encode position =
  let
    encodeFloats list =
      Encode.list (List.map Encode.float list)
  in
    case position of
      LonLat lon lat ->
        encodeFloats [ lon, lat ]

      LonLatAlt lon lat alt ->
        encodeFloats [ lon, lat, alt ]

      EastingNorthing easting northing ->
        encodeFloats [ easting, northing ]

      EastingNorthingAlt easting northing alt ->
        encodeFloats [ easting, northing, alt ]


encodeList : List Position -> Encode.Value
encodeList positionList =
  Encode.list (List.map encode positionList)


decode : Decode.Decoder Position
decode =
  Decode.oneOf
    [ Decode.tuple3 fromLonLatAlt Decode.float Decode.float Decode.float
    , Decode.tuple2 fromLonLat Decode.float Decode.float
    ]
