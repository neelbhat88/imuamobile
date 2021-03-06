angular.module('myApp')
.config ['$stateProvider', 'CONSTANTS', ($stateProvider, CONSTANTS) ->
	$stateProvider.state 'home.students',
		url:  '/students/:id',
		views: 
			'menuContent':
				templateUrl: 'students/students.html',
				controller: 'StudentsCtrl',
				resolve:
					current_user: (SessionService) ->
						SessionService.getCurrentUser()
				data:
					authorizedRoles: [CONSTANTS.USER_ROLES.super_admin, CONSTANTS.USER_ROLES.org_admin]

]
