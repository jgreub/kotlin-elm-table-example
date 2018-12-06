import Browser exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as JD

import GenericTable.Core exposing (Page, QueryOptions, FilterEvent)
import GenericTable.Update exposing (updateQueryOptionsFilter)
import GenericTable.View exposing (drawTable, PropertyInfo)
import GenericTable.Cmd exposing (getData)

main =
  document
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

init : () -> (Model, Cmd Msg)
init _ =
  let
    initialModel = Model {content = []} (QueryOptions [] Nothing)
  in
    (initialModel, getData (\result -> GotFruits result) "/fruit" initialModel.queryOptions decodeFruit)


-- MODEL

type alias Model =
  { fruits: Page Fruit
  , queryOptions: QueryOptions
  }

type alias Fruit =
  { name : String
  , color: String
  }


-- UPDATE

type Msg
  = GotFruits (Result Http.Error (Page Fruit))
  | UpdateFilter FilterEvent

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    GotFruits (Ok fruits) ->
      ({model | fruits = fruits}, Cmd.none)

    GotFruits (Err _) ->
      ({model | fruits = {content = []}}, Cmd.none)

    UpdateFilter filter ->
      let
        newQueryOptions = updateQueryOptionsFilter model.queryOptions filter
      in
        ({model | queryOptions = newQueryOptions}, getData (\result -> GotFruits result) "/fruit" newQueryOptions decodeFruit)


-- VIEW

view : Model -> Document Msg
view model =
  Document
    "Generic Tables"
    [ div [] [ drawTable (\filter -> UpdateFilter filter) fruitColumns model.fruits ] ]

fruitColumns : List (PropertyInfo Fruit)
fruitColumns = [ ("name", .name), ("color", .color) ]


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none


-- DECODER

decodeFruit : JD.Decoder Fruit
decodeFruit =
  JD.map2 Fruit
    (JD.field "name" JD.string)
    (JD.field "color" JD.string)
