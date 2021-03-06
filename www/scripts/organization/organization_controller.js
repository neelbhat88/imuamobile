(function() {
  angular.module('myApp').controller('OrganizationCtrl', [
    '$scope', '$modal', '$stateParams', 'current_user', 'UsersService', 'ProgressService', 'ExpectationService', 'OrganizationService', function($scope, $modal, $stateParams, current_user, UsersService, ProgressService, ExpectationService, OrganizationService) {
      $scope.current_user = current_user;
      $scope.current_organization = $scope.current_user.organization_name;
      $scope.mentors_with_attention_students = [];
      $('input, textarea').placeholder();
      OrganizationService.getOrganizationWithUsers($stateParams.id).success(function(data) {
        $scope.organization = OrganizationService.parseOrganizationWithUsers(data.organization);
        $scope.groupedStudents = $scope.organization.groupedStudents;
        $scope.org_milestones = $scope.organization.org_milestones;
        $scope.active_mentors = $scope.organization.active_mentors;
        $scope.active_students = $scope.organization.active_students;
        $scope.total_gpa = $scope.organization.total_gpa;
        $scope.semester_gpa = $scope.organization.semester_gpa;
        $scope.total_serviceHours = $scope.organization.total_serviceHours;
        $scope.semester_serviceHours = $scope.organization.semester_serviceHours;
        $scope.total_ecActivities = $scope.organization.total_ecActivities;
        $scope.semester_ecActivities = $scope.organization.semester_ecActivities;
        $scope.total_testsTaken = $scope.organization.total_testsTaken;
        $scope.semester_testsTaken = $scope.organization.semester_testsTaken;
        $scope.average_gpa = $scope.organization.average_gpa;
        $scope.average_serviceHours = $scope.organization.average_serviceHours;
        $scope.average_ecActivities = $scope.organization.average_ecActivities;
        $scope.average_testsTaken = $scope.organization.average_testsTaken;
        $scope.mentor_needs_help = "1*";
        $scope.mentors_with_attention_students = _.filter($scope.organization.mentors, function(mentor) {
          return _.intersection(mentor.studentIds, $scope.organization.attention_studentIds).length > 0;
        });
        return $scope.loaded_users = true;
      });
      $scope.fullName = function(user) {
        if (user.id === current_user.id) {
          return "Me";
        } else {
          return user.first_name + " " + user.last_name;
        }
      };
      return $scope.addMentor = function() {
        var modalInstance;
        modalInstance = $modal.open({
          templateUrl: 'organization/add_user_modal.html',
          controller: 'AddUserModalController',
          backdrop: 'static',
          size: 'sm',
          resolve: {
            current_user: function() {
              return $scope.current_user;
            },
            organization: function() {
              return $scope.organization;
            },
            new_user: function() {
              return UsersService.newMentor($scope.organization.id);
            }
          }
        });
        return modalInstance.result.then(function(user) {
          $scope.organization.mentors.push(user);
          return $scope.addSuccessMessage("Email with password has been sent to " + user.email);
        });
      };
    }
  ]);

}).call(this);
