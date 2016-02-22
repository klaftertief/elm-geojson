module Tests (..) where

import ElmTest exposing (..)
import Fixtures.Geometry as Geometry
import Fixtures.Json.Geometry as JsonGeometry
import GeoJson.Simple as GeoJson exposing (GeoJson)
import Json.Decode exposing (decodeString, decodeValue)
import Json.Encode exposing (encode)
import Result


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
    [ test "Point"
        <| assertEqual
            (encode 0 <| GeoJson.encode Geometry.point)
            JsonGeometry.point
    ]


decoding : Test
decoding =
  suite
    "Decoding"
    [ test "Point"
        <| assertEqual
            (decodeFromString JsonGeometry.point)
            (Result.Ok Geometry.point)
    , test "Point (Just Result)"
        <| assertDecode (decodeFromString JsonGeometry.point)
    , test "MultiPoint (Just Result)"
        <| assertDecode (decodeFromString JsonGeometry.multiPoint)
    , test "LineString (Just Result)"
        <| assertDecode (decodeFromString JsonGeometry.lineString)
    , test "MultiLineString (Just Result)"
        <| assertDecode (decodeFromString JsonGeometry.multiLineString)
    , test "Polygon (Just Result)"
        <| assertDecode (decodeFromString JsonGeometry.polygon)
    , test "Polygon with Holes (Just Result)"
        <| assertDecode (decodeFromString JsonGeometry.polygonWithHoles)
    , test "MultiPolygon (Just Result)"
        <| assertDecode (decodeFromString JsonGeometry.multiPolygon)
    , test "GeometryCollection (Just Result)"
        <| assertDecode (decodeFromString JsonGeometry.geometryCollection)
    , test "Feature (Just Result)"
        <| assertDecode (decodeFromString JsonGeometry.feature)
    , test "FeatureCollection (Just Result)"
        <| assertDecode (decodeFromString JsonGeometry.featureCollection)
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
    , test "MultiPoint (Value)"
        <| assertEqual
            (decodeValue GeoJson.decode (GeoJson.encode Geometry.multiPoint))
            (Result.Ok Geometry.multiPoint)
    , test "lineString (Value)"
        <| assertEqual
            (decodeValue GeoJson.decode (GeoJson.encode Geometry.lineString))
            (Result.Ok Geometry.lineString)
    , test "multiLineString (Value)"
        <| assertEqual
            (decodeValue GeoJson.decode (GeoJson.encode Geometry.multiLineString))
            (Result.Ok Geometry.multiLineString)
    , test "polygon (Value)"
        <| assertEqual
            (decodeValue GeoJson.decode (GeoJson.encode Geometry.polygon))
            (Result.Ok Geometry.polygon)
    , test "multiPolygon (Value)"
        <| assertEqual
            (decodeValue GeoJson.decode (GeoJson.encode Geometry.multiPolygon))
            (Result.Ok Geometry.multiPolygon)
    , test "geometryCollection (Value)"
        <| assertEqual
            (decodeValue GeoJson.decode (GeoJson.encode Geometry.geometryCollection))
            (Result.Ok Geometry.geometryCollection)
    , test "featurePoint (Value)"
        <| assertEqual
            (decodeValue GeoJson.decode (GeoJson.encode Geometry.featurePoint))
            (Result.Ok Geometry.featurePoint)
    , test "featureLineString (Value)"
        <| assertEqual
            (decodeValue GeoJson.decode (GeoJson.encode Geometry.featureLineString))
            (Result.Ok Geometry.featureLineString)
    , test "featurePolygon (Value)"
        <| assertEqual
            (decodeValue GeoJson.decode (GeoJson.encode Geometry.featurePolygon))
            (Result.Ok Geometry.featurePolygon)
    , test "featureGeometryCollection (Value)"
        <| assertEqual
            (decodeValue GeoJson.decode (GeoJson.encode Geometry.featureGeometryCollection))
            (Result.Ok Geometry.featureGeometryCollection)
    , test "featureCollection (Value)"
        <| assertEqual
            (decodeValue GeoJson.decode (GeoJson.encode Geometry.featureCollection))
            (Result.Ok Geometry.featureCollection)
    ]


all : Test
all =
  suite
    "GeoJson"
    [ encoding
    , decoding
    , fullCircle
    ]
