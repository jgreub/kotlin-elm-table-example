import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as JD
import Tuple exposing (first, second)

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
  div [] [ drawTable [ ("name", .name), ("color", .color) ] model.fruits ]

type alias PropertyInfo a =
  (String, a -> String)

drawTable : List (PropertyInfo a) -> List a -> Html Msg
drawTable propertyInfo data =
  let
    propertyNames = List.map first propertyInfo
    propertyAccessors = List.map second propertyInfo

    headerRow = drawHeaderRow propertyNames
    filterRow = drawFilterRow propertyNames
    dataRows = List.map (\x -> drawDataRow propertyAccessors x) data
  in
    table [] (headerRow :: filterRow :: dataRows)

drawHeaderRow : List String -> Html Msg
drawHeaderRow names =
  thead [ style [ ("backgroundColor", "lightgray") ] ] [ tr [] (List.map drawHeader names) ]

drawHeader : String -> Html Msg
drawHeader name =
  td [] [text name]

drawFilterRow : List String -> Html Msg
drawFilterRow filterNames =
  tr [] (List.map drawFilter filterNames)

drawFilter : String -> Html Msg
drawFilter filterName =
  td [] [ input [ onInput (createOnFilterChange filterName), placeholder "Filter..." ] [] ]

createOnFilterChange : String -> String -> Msg
createOnFilterChange filterName filterValue =
  UpdateFilter (Filter filterName filterValue)

drawDataRow : List (a -> String) -> a -> Html Msg
drawDataRow accessors datum =
  tr [] (List.map (\x -> drawDataColumn x datum) accessors)

drawDataColumn : (a -> String) -> a -> Html Msg
drawDataColumn accessor datum =
  td [] [text (accessor datum)]


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