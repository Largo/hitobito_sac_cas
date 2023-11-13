# frozen_string_literal: true

#  Copyright (c) 2012-2023, Schweizer Alpen-Club. This file is part of
#  hitobito_sac_cas and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_sac_cas.

require 'spec_helper'

describe 'person show page' do
  let(:admin) { people(:admin) }
  let(:mitglied) { people(:mitglied) }
  let(:geschaeftsstelle) { groups(:geschaeftsstelle) }
  let(:mitglieder) { groups(:bluemlisalp_mitglieder) }
  let(:other) do
    Fabricate(Group::Sektion.sti_name, parent: groups(:root), foundation_year: 2023)
    .children.find_by(type: Group::SektionsMitglieder)
  end


  describe 'roles' do
    describe 'her own' do
      before { sign_in(admin) }

      it 'shows link to change main group' do
        visit group_person_path(group_id: geschaeftsstelle.id, id: admin.id)
        expect(page).to have_link 'Hauptgruppe setzen'
      end

      it 'hides link to change main group if person is Mitglied in a Sektion' do
        Fabricate(Group::SektionsMitglieder::Mitglied.sti_name, group: mitglieder, person: admin, beitragskategorie: :einzel)
        visit group_person_path(group_id: geschaeftsstelle.id, id: admin.id)
        expect(page).not_to have_link 'Hauptgruppe setzen'
        expect(page).to have_css('section.roles', text: "SAC Blüemlisalp / Mitglieder\nMitglied (Einzel)")
      end

      it 'labels role as Zusatzsektion' do
        travel_to 1.day.ago do
          Fabricate(Group::SektionsMitglieder::Mitglied.sti_name, group: mitglieder, person: admin, beitragskategorie: :einzel)
        end
        secondary = Fabricate(Group::SektionsMitglieder::Mitglied.sti_name, group: other, person: admin, beitragskategorie: :einzel)
        secondary_name = [secondary.group.parent.to_s, secondary.group.to_s].join(" / ")

        visit group_person_path(group_id: geschaeftsstelle.id, id: admin.id)
        expect(page).not_to have_link 'Hauptgruppe setzen'
        expect(page).to have_css('section.roles', text: "SAC Blüemlisalp / Mitglieder\nMitglied (Einzel)")
        expect(page).to have_css('section.roles', text: "#{secondary_name}\nMitglied (Einzel) (Zusatzsektion)")
      end
    end

    describe 'others' do
      before { sign_in(admin) }

      it 'shows Hauptgruppe setzen link to ' do
        visit group_person_path(group_id: geschaeftsstelle.id, id: admin.id)
        expect(page).to have_link 'Hauptgruppe setzen'
      end

      it 'shows icon Hauptsektion icon' do
        visit group_person_path(group_id: mitglieder.id, id: mitglied.id)
        expect(page).to have_css "i.fa.fa-star"
        expect(page).to have_xpath "//i[@filled='true']"
        expect(page).to have_xpath "//i[@title='Hauptsektion']"
      end

      context 'with two sektion memberships' do
        let!(:secondary) { Fabricate(Group::SektionsMitglieder::Mitglied.sti_name, group: other, person: mitglied, beitragskategorie: :einzel) }
        let(:secondary_name) { [secondary.group.parent.to_s, secondary.group.to_s].join(" / ") }

        it 'changing main sektion updates roles aside' do
          visit group_person_path(group_id: mitglieder.id, id: mitglied.id)
          expect(page).to have_link 'Hauptsektion setzen', count: 1
          expect(page).to have_css('section.roles', text: "SAC Blüemlisalp / Mitglieder\nMitglied (Einzel)")
          expect(page).to have_css('section.roles', text: "#{secondary_name}\nMitglied (Einzel) (Zusatzsektion)")

          click_link 'Hauptsektion setzen'

          expect(page).to have_css('section.roles', text: "SAC Blüemlisalp / Mitglieder\nMitglied (Einzel) (Zusatzsektion)")
          expect(page).to have_css('section.roles', text: "#{secondary_name}\nMitglied (Einzel)")
          expect(page).to have_link 'Hauptsektion setzen', count: 1
        end

        it 'only allows to change main sektion not main group' do
          Fabricate(Group::Geschaeftsstelle::ITSupport.sti_name, group: geschaeftsstelle, person: mitglied)
          visit group_person_path(group_id: mitglieder.id, id: mitglied.id)
          expect(page).not_to have_link 'Hauptgruppe setzen'
        end
      end
    end
  end
end