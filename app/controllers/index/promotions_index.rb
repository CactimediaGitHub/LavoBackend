module Index
  class PromotionsIndex < BaseIndex
    def promotions(scope = Promotion)
      @promotions ||= prepare_records(scope)
    end
  end
end