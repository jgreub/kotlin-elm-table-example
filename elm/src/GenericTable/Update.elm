module GenericTable.Update exposing (updateFilter)

import GenericTable.Core exposing (Filter)

updateFilter : List Filter -> Filter -> List Filter
updateFilter filters filter =
  let
    filteredFilters = List.filter (\f -> f.name /= filter.name) filters
  in
    if String.isEmpty filter.value then
      filteredFilters
    else
      filter :: filteredFilters