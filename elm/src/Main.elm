import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as JD

import GenericTable.Core exposing (Filter)
import GenericTable.Update exposing (updateFilter)
import GenericTable.View exposing (drawTable)
import GenericTable.Cmd exposing (getData)

main =
  Html.program
  { init = init
  , view = view
  , update = update
  , subscriptions = subscriptions
  }

init : (Model, Cmd Msg)
init =
  let
    initialModel = Model [] []
  in
    (initialModel, getData (\result -> GotFruits result) "/fruit" initialModel.filters decodeFruit)


-- MODEL

type alias Model =
  { fruits: List Fruit
  , filters: List Filter
  }

type alias Fruit =
  { name : String
  , color: String
  }


-- UPDATE

type Msg
  = GotFruits (Result Http.Error (List Fruit))
  | UpdateFilter Filter

update: Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    GotFruits (Ok fruits) ->
      ({model | fruits = fruits}, Cmd.none)

    GotFruits (Err _) ->
      ({model | fruits = []}, Cmd.none)

    UpdateFilter filter ->
      let
        newFilters = updateFilter model.filters filter
      in
        ({model | filters = newFilters}, getData (\result -> GotFruits result) "/fruit" newFilters decodeFruit)


-- VIEW

view : Model -> Html Msg
view model =
  div [] [ drawTable (\filter -> UpdateFilter filter) [ ("name", .name), ("color", .color) ] model.fruits ]


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none


-- DECODER

decodeFruit : JD.Decoder (List Fruit)
decodeFruit =
  JD.list
    (JD.map2 Fruit
        (JD.field "name" JD.string)
        (JD.field "color" JD.string))
