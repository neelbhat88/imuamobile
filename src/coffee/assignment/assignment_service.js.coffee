angular.module('myApp')
.service 'AssignmentService', ['$http', '$q', 'CONSTANTS', ($http, $q, CONSTANTS) ->

# "Assignment" is owned by the assigner.
# "UserAssignment" is owned by the assignee(s).
#
# "Broadcast" and "Collect" include the associated
# UserAssignments with the parent Assignment object.

  self = this

  @setUserAssignmentStatus = (user_assignment, status) ->
    new_user_assignment = @newUserAssignment(user_assignment.user_id, user_assignment.assignment_id)
    new_user_assignment.id = user_assignment.id
    new_user_assignment.status = status

    defer = $q.defer()
    @saveUserAssignment(new_user_assignment)
      .success (data) ->
        user_assignment.status = data.user_assignment.status
        user_assignment.updated_at = data.user_assignment.updated_at
        defer.resolve(user_assignment)
    defer.promise

  @getAssignmentCollection = (assignmentId) ->
    $http.get CONSTANTS.API.base_url+"/api/v1/assignment/#{assignmentId}/collection"

  @getTaskAssignableUsers = (userId) ->
    $http.get CONSTANTS.API.base_url+"/api/v1/users/#{userId}/get_task_assignable_users"

  @getTaskAssignableUsersTasks = (userId) ->
    $http.get CONSTANTS.API.base_url+"/api/v1/users/#{userId}/get_task_assignable_users_tasks"

  @broadcastAssignment = (assignment, userIds) ->
    user_assignments = _.map(userIds, (userId) -> self.newUserAssignment(userId, assignment.id))
    if assignment.id
      $http.put CONSTANTS.API.base_url+"/api/v1/assignment/#{assignment.id}/broadcast",
        { assignment: assignment, user_assignments: user_assignments }
    else
      $http.post CONSTANTS.API.base_url+"/api/v1/users/#{assignment.user_id}/create_assignment_broadcast",
        { assignment: assignment, user_assignments: user_assignments }

  @collectUserAssignment = (userAssignmentId) ->
    $http.get CONSTANTS.API.base_url+"/api/v1/user_assignment/#{userAssignmentId}/collect"

  @collectUserAssignments = (userId) ->
    $http.get CONSTANTS.API.base_url+"/api/v1/users/#{userId}/user_assignment/collect"

  ###################################
  ########### ASSIGNMENT ############
  ###################################

  @newAssignment = (userId) ->
    user_id:          userId,
    title:            "",
    description:      "",
    due_datetime:     null

  @getAssignment = (assignmentId) ->
    $http.get CONSTANTS.API.base_url+"/api/v1/assignment/#{assignmentId}"

  @getAssignments = (userId) ->
    $http.get CONSTANTS.API.base_url+"/api/v1/users/#{userId}/assignments"

  @saveAssignment = (assignment) ->
    if assignment.id
      $http.put CONSTANTS.API.base_url+"/api/v1/assignment/#{assignment.id}", {assignment: assignment}
    else
      $http.post CONSTANTS.API.base_url+"/api/v1/users/#{assignment.user_id}/assignment", {assignment: assignment}

  @deleteAssignment = (assignmentId) ->
    $http.delete CONSTANTS.API.base_url+"/api/v1/assignment/#{assignmentId}"

  ############################################
  ############# USER ASSIGNMENT ##############
  ############################################

  @newUserAssignment = (userId, assignmentId) ->
    user_id:        userId,
    assignment_id:  assignmentId,
    status:         0

  @getUserAssignments = (userId) ->
    $http.get CONSTANTS.API.base_url+"/api/v1/users/#{userId}/user_assignment"

  @saveUserAssignment = (userAssignment) ->
    if userAssignment.id
      $http.put CONSTANTS.API.base_url+"/api/v1/user_assignment/#{userAssignment.id}", {user_assignment: userAssignment}
    else
      $http.post CONSTANTS.API.base_url+"/api/v1/users/#{userAssignment.user_id}/user_assignment", {user_assignment: userAssignment}

  @deleteUserAssignment = (userAssignmentId) ->
    $http.delete CONSTANTS.API.base_url+"/api/v1/user_assignment/#{userAssignmentId}"

  @
]
