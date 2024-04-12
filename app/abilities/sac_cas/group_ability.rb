# frozen_string_literal: true

#  Copyright (c) 2024, Schweizer Alpen-Club. This file is part of
#  hitobito_sac_cas and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_sac_cas

module SacCas::GroupAbility
  extend ActiveSupport::Concern

  prepended do
    on(Group) do
      permission(:layer_and_below_read).
        may(:export_mitglieder).
        in_same_layer_or_below
    end
  end

end
