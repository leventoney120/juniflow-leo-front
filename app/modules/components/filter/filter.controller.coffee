###
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#
# Copyright (c) 2021-present Kaleidos Ventures SL
###

class FilterController
    @.$inject = [
        '$translate',
    ]

    @.activeCustomFilter = null
    @.repeatedFilterError = false
    @.lengthZeroError = false

    constructor: (@translate) ->
        @.opened = null
        @.filterModeOptions = ["include", "exclude"]
        @.filterModeLabels = {
            "include": @translate.instant("COMMON.FILTERS.ADVANCED_FILTERS.INCLUDE"),
            "exclude": @translate.instant("COMMON.FILTERS.ADVANCED_FILTERS.EXCLUDE"),
        }
        @.filterMode = 'include'
        @.customFilterForm = false
        @.customFilterName = ''

        @.$onChanges = (changes) ->
            if changes.selectedFilters
                @.getIncludedFilters()
                @.getExcludedFilters()

        @.includedFilters = @.getIncludedFilters()
        @.excludedFilters = @.getExcludedFilters()


    toggleFilterCategory: (filterName) ->
        if @.opened == filterName
            @.opened = null
        else
            @.opened = filterName

    isOpen: (filterName) ->
        return @.opened == filterName

    openCustomFilter: () ->
        @.customFilterForm = true
        @.lengthZeroError = false
        @.repeatedFilterError = false

    saveCustomFilter: () ->
        if @.customFilterName.length > 0 && !@.customFilters.find((filter) => filter.name == @.customFilterName)
            @.lengthZeroError = false
            @.repeatedFilterError = false
            @.onSaveCustomFilter({name: @.customFilterName})
            @.customFilterForm = false
            @.opened = 'custom-filter'
            @.customFilterName = ''

        if @.customFilterName.length == 0
            @.lengthZeroError = true
        else
            @.lengthZeroError = false

        if !@.customFilters.find((filter) => filter.name == @.customFilterName)
            @.repeatedFilterError = false
        else
            @.repeatedFilterError = true

    unselectFilter: (filter) ->
        @.activeCustomFilter = null
        @.onRemoveFilter({filter: filter})

    selectFilter: (filterCategory, filter) ->
        filter = {
            category: filterCategory
            filter: filter
            mode: @.filterMode
        }
        @.activeCustomFilter = null
        @.onAddFilter({filter: filter})

    removeCustomFilter: (filter) ->
        @.activeCustomFilter = null
        @.onRemoveCustomFilter({filter: filter})

    selectCustomFilter: (filter) ->
        @.activeCustomFilter = filter.id
        @.onSelectCustomFilter({filter: filter})

    getIncludedFilters: () ->
        @.includedFilters = _.filter @.selectedFilters, (it) ->
            return it.mode == 'include'

    getExcludedFilters: () ->
        @.excludedFilters = _.filter @.selectedFilters, (it) ->
            return it.mode == 'exclude'

    isFilterSelected: (filterCategory, filter) ->
        return !!_.find @.selectedFilters, (it) ->
            return filter.id == it.id && filterCategory.dataType == it.dataType

angular.module('taigaComponents').controller('Filter', FilterController)
