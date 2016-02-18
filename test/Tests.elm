module Tests (..) where

import ElmTest exposing (..)
import Fixtures.Geometry as Geometry
import Fixtures.Json.Geometry as JsonGeometry
import GeoJson exposing (GeoJson)
import Json.Decode exposing (decodeString, decodeValue)
import Json.Encode exposing (encode)
import Result


_ =
  Debug.log
    "Ladida"
    (let
      result =
        decodeFromString JsonGeometry.featureCollection
     in
      case result of
        Result.Ok geoJson ->
          encode 0 <| GeoJson.encode geoJson

        Result.Err _ ->
          encode 0 <| GeoJson.encode Geometry.point
    )


decodeFromString : String -> Result.Result String GeoJson
decodeFromString string =
  decodeString GeoJson.decode string


assertDecode : Result.Result String GeoJson -> ElmTest.Assertion
assertDecode result =
  assert
    <| case result of
        Result.Ok _ ->
          True

        Result.Err _ ->
          False


encoding : Test
encoding =
  suite
    "Encoding"
    [ test "Point Encoder"
        <| assertEqual
            (encode 0 <| GeoJson.encode Geometry.point)
            JsonGeometry.point
    , test "GeometryCollection (Just Result)"
        <| assertDecode (decodeFromString JsonGeometry.geometryCollection)
    , test "Feature (Just Result)"
        <| assertDecode (decodeFromString JsonGeometry.feature)
    , test "FeatureCollection (Just Result)"
        <| assertDecode (Debug.log "???" <| decodeFromString JsonGeometry.featureCollection)
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
