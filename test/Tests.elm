module Tests (..) where

import ElmTest exposing (..)
import Fixtures.Geometry as Geometry
import Fixtures.Json.Geometry as JsonGeometry
import GeoJson exposing (GeoJson)
import Json.Decode exposing (decodeString, decodeValue)
import Json.Encode exposing (encode)
import Result


decodeFromString : String -> Result.Result String GeoJson
decodeFromString string =
  decodeString GeoJson.decode string



--_ =
--  Debug.log "DECODE???" (decodeFromString JsonGeometry.multiLineString)


encoding : Test
encoding =
  suite
    "Encoding"
    [ test "Point Encoder"
        <| assertEqual
            (encode 0 <| GeoJson.encode Geometry.point)
            JsonGeometry.point
    ]


decoding : Test
decoding =
  suite
    "Decoding"
    [ test "Point Decoder"
        <| assertEqual
            (decodeFromString JsonGeometry.point)
            (Result.Ok Geometry.point)
    ]


fullCircle : Test
fullCircle =
  suite
    "Full circle"
    [ test "Point (String)"
        <| assertEqual
            (decodeFromString (encode 0 <| GeoJson.encode Geometry.point))
            (Result.Ok Geometry.point)
    , test "Point (Value)"
        <| assertEqual
            (decodeValue GeoJson.decode (GeoJson.encode Geometry.point))
            (Result.Ok Geometry.point)
    ]


all : Test
all =
  suite
    "GeoJson"
    [ encoding
    , decoding
    , fullCircle
    ]
