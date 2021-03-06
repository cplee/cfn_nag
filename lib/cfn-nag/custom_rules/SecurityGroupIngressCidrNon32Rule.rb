require 'cfn-nag/violation'
require_relative 'base'
require 'cfn-nag/ip_addr'

class SecurityGroupIngressCidrNon32Rule < BaseRule
  include IpAddr

  def rule_text
    'Security Groups found with ingress cidr that is not /32'
  end

  def rule_type
    Violation::WARNING
  end

  def rule_id
    'W9'
  end

  ##
  # This will behave slightly different than the legacy jq based rule which was targeted against inline ingress only
  def audit_impl(cfn_model)
    logical_resource_ids = []
    cfn_model.security_groups.each do |security_group|
      violating_ingresses = security_group.securityGroupIngress.select do |ingress|
        ip4_cidr_range?(ingress) || ip6_cidr_range?(ingress)
      end

      unless violating_ingresses.empty?
        logical_resource_ids << security_group.logical_resource_id
      end
    end

    violating_ingresses = cfn_model.standalone_ingress.select do |standalone_ingress|
      ip4_cidr_range?(standalone_ingress) || ip6_cidr_range?(standalone_ingress)
    end

    logical_resource_ids + violating_ingresses.map { |ingress| ingress.logical_resource_id}
  end
end

