require 'cfn-nag/violation'
require_relative 'base'

class IamRoleNotActionOnTrustPolicyRule < BaseRule

  def rule_text
    'IAM role should not allow Allow+NotAction on trust permissions'
  end

  def rule_type
    Violation::WARNING
  end

  def rule_id
    'W14'
  end

  def audit_impl(cfn_model)
    violating_roles = cfn_model.resources_by_type('AWS::IAM::Role').select do |role|
      !role.assumeRolePolicyDocument.allows_not_action.empty?
    end

    violating_roles.map { |role| role.logical_resource_id }
  end
end
