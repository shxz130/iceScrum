<%@ page import="org.icescrum.core.domain.Story; grails.converters.JSON" %>
%{--
- Copyright (c) 2014 Kagilum SAS.
-
- This file is part of iceScrum.
-
- iceScrum is free software: you can redistribute it and/or modify
- it under the terms of the GNU Affero General Public License as published by
- the Free Software Foundation, either version 3 of the License.
-
- iceScrum is distributed in the hope that it will be useful,
- but WITHOUT ANY WARRANTY; without even the implied warranty of
- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- GNU General Public License for more details.
-
- You should have received a copy of the GNU Affero General Public License
- along with iceScrum.  If not, see <http://www.gnu.org/licenses/>.
-
- Authors:
-
- Vincent Barrier (vbarrier@kagilum.com)
- Nicolas Noullet (nnoullet@kagilum.com)
--}%
<div class="panel panel-light">
    <div class="panel-heading">
        <div class="btn-toolbar">
            <div class="btn-group">
                <button type="button"
                        ng-if="isSortableFeature()"
                        class="btn btn-default"
                        ng-click="orderByRank()"
                        uib-tooltip="${message(code:'todo.is.ui.changeRank')}"
                        tooltip-append-to-body="true">
                    <span ng-class="isSortingFeature() ? 'text-success' : 'text-danger'" class=" fa fa-hand-pointer-o"></span>
                </button>
                <div class="btn-group"
                     uib-dropdown
                     tooltip-append-to-body="true"
                     uib-tooltip="${message(code:'todo.is.ui.sort')}">
                    <button class="btn btn-default"
                            uib-dropdown-toggle type="button">
                        <span id="sort">{{ orderBy.current.name }}</span>
                        <span class="caret"></span>
                    </button>
                    <ul class="uib-dropdown-menu" role="menu">
                        <li role="menuitem" ng-repeat="order in orderBy.values">
                            <a ng-click="orderBy.current = order" href>{{ order.name }}</a>
                        </li>
                    </ul>
                </div>
                <button type="button"
                        class="btn btn-default"
                        ng-click="orderBy.reverse = !orderBy.reverse"
                        uib-tooltip="${message(code:'todo.is.ui.order')}"
                        tooltip-append-to-body="true">
                    <span class="fa fa-sort-amount{{ orderBy.reverse ? '-desc' : '-asc'}}"></span>
                </button>
            </div>
            <div class="btn-group"
                 uib-dropdown
                 tooltip-append-to-body="true"
                 uib-tooltip="${message(code:'todo.is.ui.export')}">
                <button class="btn btn-default"
                        uib-dropdown-toggle
                        type="button">
                    <span class="fa fa-download"></span>&nbsp;<span class="caret"></span>
                </button>
                <ul class="uib-dropdown-menu"
                    role="menu">
                    <g:each in="${is.exportFormats()}" var="format">
                        <li role="menuitem">
                            <a href="${createLink(action:format.action?:'print',controller:format.controller?:controllerName,params:format.params)}"
                               ng-click="print($event)">${format.name}</a>
                        </li>
                    </g:each>
                    <entry:point id="${controllerName}-toolbar-export" model="[product:params.product, origin:controllerName]"/>
                </ul>
            </div>
            <a type="button"
               ng-if="authorizedFeature('create')"
               uib-tooltip="${message(code:'default.button.create.label')}"
               tooltip-append-to-body="true"
               tooltip-placement="right"
               href="#/{{ ::viewName }}/new"
               class="btn btn-primary pull-right">${message(code: "todo.is.ui.feature.new")}</a>
            <div class="btn-group pull-right visible-on-hover">
                <entry:point id="${controllerName}-${actionName}-toolbar-right"/>
                <g:if test="${params?.printable}">
                    <button type="button"
                            class="btn btn-default"
                            uib-tooltip="${message(code:'is.ui.window.print')} (P)"
                            tooltip-append-to-body="true"
                            tooltip-placement="bottom"
                            ng-click="print($event)"
                            ng-href="{{ ::viewName }}/print"
                            hotkey="{'P': hotkeyClick }"><span class="fa fa-print"></span>
                    </button>
                </g:if>
                <button type="button"
                        uib-tooltip="${message(code:'todo.is.ui.toggle.grid.list')}"
                        tooltip-append-to-body="true"
                        tooltip-placement="right"
                        ng-click="app.asList = !app.asList"
                        class="btn btn-default">
                    <span class="fa fa-th" ng-class="{'fa-th-list': app.asList, 'fa-th': !app.asList}"></span>
                </button>
                <g:if test="${params?.fullScreen}">
                    <button type="button"
                            class="btn btn-default"
                            ng-show="!app.isFullScreen"
                            ng-click="fullScreen()"
                            uib-tooltip="${message(code:'is.ui.window.fullscreen')} (F)"
                            tooltip-append-to-body="true"
                            tooltip-placement="bottom"
                            hotkey="{'F': fullScreen }"><span class="fa fa-expand"></span>
                    </button>
                    <button type="button"
                            class="btn btn-default"
                            ng-show="app.isFullScreen"
                            uib-tooltip="${message(code:'is.ui.window.fullscreen')}"
                            tooltip-append-to-body="true"
                            tooltip-placement="bottom"
                            ng-click="fullScreen()"><span class="fa fa-compress"></span>
                    </button>
                </g:if>
            </div>
        </div>
    </div>
    <div class="panel-body">
        <div class="postits {{ isSortingFeature() ? '' : 'sortable-disabled' }}"
             ng-class="app.asList ? 'list-group' : 'grid-group'"
             as-sortable="featureSortableOptions"
             is-disabled="!isSortingFeature()"
             ng-model="features">
            <div ng-class="{ 'ui-selected': isSelected(feature) }"
                 data-id="{{ feature.id }}"
                 as-sortable-item
                 ng-repeat="feature in features | orderBy:orderBy.current.id:orderBy.reverse"
                 ng-controller="featureCtrl"
                 class="postit-container">
                <div ng-include="'feature.html'"></div>
            </div>
        </div>
    </div>
</div>