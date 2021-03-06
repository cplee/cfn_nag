require 'cfn-nag/violation'
require_relative 'base'

class SnsTopicPolicyWildcardPrincipalRule < BaseRule

  def rule_text
    'SNS topic policy should not allow * principal'
  end

  def rule_type
    Violation::FAILING_VIOLATION
  end

  def rule_id
    'F18'
  end

  def audit_impl(cfn_model)
    logical_resource_ids = []

    cfn_model.resources_by_type('AWS::SNS::TopicPolicy').each do |topic_policy|
      if !topic_policy.policyDocument.wildcard_allowed_principals.empty?
        logical_resource_ids << topic_policy.logical_resource_id
      end
    end

    logical_resource_ids
  end
end
