module GeoJson.Feature (Feature, encode, decode) where

import Dict exposing (Dict)
import GeoJson.Geometry as Geometry exposing (Geometry)
import Json.Decode as Decode exposing ((:=))
import Json.Encode as Encode


type Feature
  = Feature Geometry Properties (Maybe Id)
  | Collection (List Feature)


type alias Properties =
  Dict String String


type alias Id =
  String


encode : Feature -> Encode.Value
encode feature =
  case feature of
    Feature geometry properties maybeId ->
      let
        baseValues =
          [ ( "type", Encode.string "Feature" )
          , ( "geometry", Geometry.encode geometry )
          , ( "properties", encodeProperties properties )
          ]

        allValues =
          case maybeId of
            Just id ->
              ( "id", encodeId id ) :: baseValues

            Nothing ->
              baseValues
      in
        Encode.object allValues

    Collection features ->
      Encode.object
        [ ( "type", Encode.string "FeatureCollection" )
        , ( "features"
          , Encode.list (List.map encode features)
          )
        ]


encodeProperties : Properties -> Encode.Value
encodeProperties properties =
  Encode.object
    <| List.map
        (\( key, value ) -> ( key, Encode.string value ))
        (Dict.toList properties)


encodeId : Id -> Encode.Value
encodeId id =
  Encode.string id


decode : Decode.Decoder Feature
decode =
  ("type" := Decode.string)
    |> (flip Decode.andThen) decodeType


decodeType : String -> Decode.Decoder Feature
decodeType tipe =
  case tipe of
    "Feature" ->
      Decode.object3
        Feature
        ("geometry" := Geometry.decode)
        ("properties" := Decode.dict Decode.string)
        (Decode.maybe ("id" := Decode.string))

    "FeatureCollection" ->
      Decode.object1
        Collection
        ("features" := Decode.list decode)

    _ ->
      Decode.fail ("Feature type '" ++ tipe ++ "' not supported.")
