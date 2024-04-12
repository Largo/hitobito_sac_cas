# frozen_string_literal: true

#  Copyright (c) 2024, Schweizer Alpen-Club. This file is part of
#  hitobito_sac_cas and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_sac_cas

module Export::Tabular::People
  class SacMitglieder < Export::Tabular::Base

    self.model_class = ::Person
    self.row_class = Export::Tabular::People::SacMitgliedRow

    attr_reader :group


    def initialize(group)
      unless group.is_a?(Group::Sektion) || group.is_a?(Group::Ortsgruppe)
        raise ArgumentError, 'Argument must be a Sektion or Ortsgruppe'
      end

      @group = group
      super(mitglieder)
    end

    def labels
      nil
    end

    def attributes # rubocop:disable Metrics/MethodLength
      [
        :id,
        :layer_navision_id,
        :first_name,
        :last_name,
        :adresszusatz,
        :address,
        :postfach,
        :zip_code,
        :town,
        :country,
        :birthday,
        :phone_number_direct,
        :phone_number_private,
        :empty, # 1 leere Spalte
        :phone_number_mobile,
        :phone_number_fax,
        :email,
        :gender,
        :empty, # 1 leere Spalte
        :language,
        :eintrittsjahr,
        :begünstigt,
        :ehrenmitglied,
        :beitragskategorie,
        :s_info_1,
        :s_info_2,
        :s_info_3,
        :bemerkungen,
        :saldo,
        :empty, # 1 leere Spalte
        :anzahl_die_alpen,
        :anzahl_sektionsbulletin
      ]
    end

    private

    def mitglieder
      Person.
        where(roles: {
                group_id: non_layer_children_ids,
                type: SacCas::MITGLIED_ROLES - SacCas::NEUANMELDUNG_ROLES
              }).
        joins(:roles).
        includes(:phone_numbers, :roles_with_deleted, roles: :group).
        distinct
    end

    def non_layer_children_ids
      group.children.reject(&:layer?).map(&:id)
    end

    def row_for(entry, format = nil)
      row_class.new(entry, group, format)
    end

  end
end
