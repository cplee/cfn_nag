require 'cfn-nag/violation'
require_relative 'base'

class SnsTopicPolicyNotPrincipalRule < BaseRule

  def rule_text
    'SNS Topic policy should not allow Allow+NotPrincipal'
  end

  def rule_type
    Violation::FAILING_VIOLATION
  end

  def rule_id
    'F8'
  end

  def audit_impl(cfn_model)
    violating_policies = cfn_model.resources_by_type('AWS::SNS::TopicPolicy').select do |policy|
      !policy.policyDocument.allows_not_principal.empty?
    end

    violating_policies.map { |policy| policy.logical_resource_id }
  end
end

