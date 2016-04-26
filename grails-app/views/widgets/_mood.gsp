<is:widget widgetDefinition="${widgetDefinition}">
    <div ng-controller="moodCtrl" ng-switch="alreadySavedToday">
        <div ng-switch-default>
            ${message(code: 'is.panel.mood.day')}
            <div class="text-center">
                <div class="mood-button text-success" ng-click="save('GOOD')" tooltip-append-to-body="false" uib-tooltip="${message(code: 'is.panel.mood.good')}"><i class="fa fa-smile-o fa-5x"></i></div>
                <div class="mood-button text-warning" ng-click="save('MEH')" tooltip-append-to-body="false" uib-tooltip="${message(code: 'is.panel.mood.meh')}"><i class="fa fa-meh-o fa-5x"></i></div>
                <div class="mood-button text-danger" ng-click="save('BAD')" tooltip-append-to-body="false" uib-tooltip="${message(code: 'is.panel.mood.bad')}"><i class="fa fa-frown-o fa-5x"></i></div>
            </div>
        </div>
        <div ng-switch-when="true">
            <table ng-repeat="mood in moods">
                <tr><td>${message(code: 'is.panel.mood.feeling')} {{mood.feeling | i18n:'MoodFeelings'}}</td>
                </tr>
            </table>
            <div ng-controller="moodChartCtrl">
                <div class="panel-body">
                    <nvd3 options="options" data="data"></nvd3>
                </div>
            </div>
        </div>
    </div>
</is:widget>