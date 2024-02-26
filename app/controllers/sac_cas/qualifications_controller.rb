# frozen_string_literal: true

#  Copyright (c) 2024, Schweizer Alpen-Club. This file is part of
#  hitobito_sac_cas and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_sac_cas

module SacCas::QualificationsController
  extend ActiveSupport::Concern

  def load_qualification_kinds
    super.tap do |qualification_kinds|
      @qualification_kinds = qualification_kinds.to_a.keep_if do |qualification_kind|
        can?(:create, @person.qualifications.new(qualification_kind: qualification_kind))
      end
    end
  end

end
