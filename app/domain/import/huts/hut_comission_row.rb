# frozen_string_literal: true

#  Copyright (c) 2023, Schweizer Alpen-Club. This file is part of
#  hitobito_sac_cas and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_sac_cas.

require Rails.root.join('lib', 'import', 'xlsx_reader.rb')

module Import::Huts
  class HutComissionRow

    def self.can_process?(row)
      row[:verteilercode].to_s == '4000.0'
    end

    def initialize(row)
      @row = row
    end

    def import!
      group = group_for(@row)
      set_data(@row, group)
      group.save!
    end

    def group_for(row)
      Group::SektionsHuettenkommission.find_or_initialize_by(parent_id: parent_id(row))
    end

    def set_data(row, group)
      group.type = Group::SektionsHuettenkommission.name
      group.name = group.class.label
      group.parent_id = parent_id(row)
    end

    def parent_id(row)
      @parent_id ||= Group::Sektion.find_by(navision_id: owner_navision_id(row)).id
    rescue
      puts "WARNING: No parent id found for row #{row.inspect}"
      raise
    end

    def owner_navision_id(row)
      row[:contact_navision_id].to_s.sub(/^[0]*/, '')
    end
  end
end
