# frozen_string_literal: true

#  Copyright (c) 2012-2023, Schweizer Alpen-Club. This file is part of
#  hitobito_sac_cas and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_sac_cas.

class Group::SektionsFunktionaere < ::Group

  self.static_name = true

  ### ROLES
  class Praesidium < ::Role
    self.permissions = []
  end

  class Mitgliederverwaltung < ::Role
    self.permissions = [:layer_and_below_full]
    self.two_factor_authentication_enforced = true
  end

  class Administration < ::Role
    self.permissions = [:layer_and_below_full]
    self.two_factor_authentication_enforced = true
  end

  class AdministrationReadOnly < ::Role
    self.permissions = [:layer_and_below_read]
    self.two_factor_authentication_enforced = true
  end

  class Umweltbeauftragte < ::Role
    self.permissions = []
    self.basic_permissions_only = true
  end

  class Kulturbeauftragte < ::Role
    self.permissions = []
    self.basic_permissions_only = true
  end

  class Andere < ::Role
    self.permissions = []
    self.basic_permissions_only = true
  end

  roles Praesidium, Mitgliederverwaltung, Administration,
    AdministrationReadOnly, Umweltbeauftragte, Kulturbeauftragte,
    Andere

end
