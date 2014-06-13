/*
 * Copyright (c) 2014 Kagilum SAS.
 *
 * This file is part of iceScrum.
 *
 * iceScrum is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published by
 * the Free Software Foundation, either version 3 of the License.
 *
 * iceScrum is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with iceScrum.  If not, see <http://www.gnu.org/licenses/>.
 *
 * Authors:
 *
 * Vincent Barrier (vbarrier@kagilum.com)
 *
 */
services.factory( 'Story', [ 'Resource', function( $resource ) {
    return $resource( 'story/:id/:action',
        { id: '@id' } ,
        {
            query:           {method:'GET', isArray:true, cache: true},
            follow:          {method:'GET', params:{action:'follow', status:false}} ,
            like:            {method:'GET', params:{action:'like', status:false}},
            activities:      {method:'GET', isArray:true, params:{action:'activities'}}
        });
}]);

services.service("StoryService", ['Story', '$q', '$timeout', '$rootScope', function(Story, $q, $timeout, $rootScope) {
    this.list = [];
    var self = this;

    this.add = function(stories){
        angular.forEach(stories, function(story) {
            self.list.push(story);
        });
        $timeout(function(){
            $rootScope.$apply();
        })
    };

    this.get = function(id){
        if (self.list.$promise){
            var story;
            var deferred = $q.defer();
            self.list.$promise.then(function(list){
                story = _.find(list , function(rw){ return rw.id == id });
                deferred.resolve(story);
            });
            return deferred.promise;
        } else {
            return _.find(self.list , function(rw){ return rw.id == id });
        }
    };

    this.update = function(story, callback){
        story.$update(function(data){
            var index = self.list.indexOf(_.find(self.list, function(st){ return st.id == story.id }));
            if (index != -1) {
                self.list.splice(index, 1, data);
            }
        });
    };

    this['delete'] = function(story){
        story.$delete(function(){
            var index = self.list.indexOf(story);
            if (index != -1) {
                self.list.splice(index, 1);
            }
        });
    };

    this.like = function(story, status){
        Story.like({ id: story.id, status:status }, function(data){
            story.like = data;
        });
    };

    this.follow = function(story, status){
        Story.follow({ id: story.id, status:status }, function(data){
            story.follow = data;
        });
    };

    this.activities = function(story){
        Story.activities({ id: story.id }, function(data){
            story.activities = data;
        });
    };

}]);
