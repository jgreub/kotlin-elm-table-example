import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as JD

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
    (initialModel, getFruits initialModel.filters)


-- MODEL

type alias Model =
  { fruits: List Fruit
  , filters: List Filter
  }

type alias Fruit =
  { name : String
  , color: String
  }

type alias Filter =
  { name: String
  , value: String
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
        ({model | filters = newFilters}, getFruits newFilters)

updateFilter : List Filter -> Filter -> List Filter
updateFilter filters filter =
  let
    filteredFilters = List.filter (\f -> f.name /= filter.name) filters
  in
    if String.isEmpty filter.value then
      filteredFilters
    else
      filter :: filteredFilters


-- VIEW

view : Model -> Html Msg
view model =
  div [] [ drawTable model.fruits ]

drawTable : List Fruit -> Html Msg
drawTable fruits =
  let
    propertyNames = [ "name", "color" ]
  in
    table [] (drawHeaderRow propertyNames :: drawFilterRow propertyNames :: (List.map drawFruitRow fruits))

drawHeaderRow : List String -> Html Msg
drawHeaderRow names =
  thead [ style [ ("backgroundColor", "lightgray") ] ] [ tr [] (List.map drawHeader names) ]

drawHeader : String -> Html Msg
drawHeader name =
  td [] [text name]

drawFilterRow : List String -> Html Msg
drawFilterRow names =
  tr [] (List.map drawFilter names)

drawFilter : String -> Html Msg
drawFilter filterName =
  td [] [ input [ onInput (createOnFilterChange filterName), placeholder ("Filter...") ] [] ]

createOnFilterChange : String -> String -> Msg
createOnFilterChange filterName =
  (\fv -> UpdateFilter (Filter filterName fv))

drawFruitRow : Fruit -> Html Msg
drawFruitRow fruit =
  tr [] [ td [] [text fruit.name], td [] [text fruit.color] ]


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none


-- HTTP

getFruits : List Filter -> Cmd Msg
getFruits filters =
  let
    queryParams = getFilterQueryParams filters
    url =
      if String.isEmpty queryParams then
        "/fruit"
      else
        "/fruit" ++ "?" ++ queryParams
  in
    Http.send GotFruits (Http.get url decodeFruits)

getFilterQueryParams : List Filter -> String
getFilterQueryParams filters =
  String.join "&" (List.map (\f -> f.name ++ "=" ++ f.value) filters)

decodeFruits : JD.Decoder (List Fruit)
decodeFruits =
  JD.list decodeFruit

decodeFruit : JD.Decoder Fruit
decodeFruit =
  JD.map2 Fruit
    (JD.field "name" JD.string)
    (JD.field "color" JD.string)