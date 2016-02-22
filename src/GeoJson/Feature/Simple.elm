module GeoJson.Feature.Simple (Feature, feature, collection, noFeature, encode, decode) where

import Dict exposing (Dict)
import GeoJson.Geometry as Geometry exposing (Geometry)
import Json.Decode as Decode exposing ((:=))
import Json.Encode as Encode


type Feature
  = One (Maybe Id) Properties Geometry
  | Collection (List Feature)
  | NoFeature


type alias Properties =
  Dict String StringOrNumber


type StringOrNumber
  = String String
  | Number Float


type alias Id =
  String


feature : Geometry -> Feature
feature =
  One Nothing Dict.empty


collection : List Feature -> Feature
collection =
  Collection


noFeature : Feature
noFeature =
  NoFeature


encode : Feature -> Encode.Value
encode feature =
  case feature of
    One maybeId properties geometry ->
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
        , ( "features", Encode.list (List.map encode features) )
        ]

    NoFeature ->
      Encode.null


encodeProperties : Properties -> Encode.Value
encodeProperties properties =
  Encode.object
    <| List.map
        (\( key, value ) ->
          ( key
          , case value of
              String string ->
                Encode.string string

              Number number ->
                Encode.float number
          )
        )
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
        One
        (Decode.maybe ("id" := Decode.string))
        ("properties" := decodeProperties)
        ("geometry" := Geometry.decode)

    "FeatureCollection" ->
      Decode.object1
        Collection
        ("features" := Decode.list decode)

    _ ->
      Decode.fail ("Feature type '" ++ tipe ++ "' not supported.")


decodeProperties : Decode.Decoder Properties
decodeProperties =
  Decode.dict
    (Decode.oneOf
      [ Decode.object1 String Decode.string
      , Decode.object1 Number Decode.float
      ]
    )
