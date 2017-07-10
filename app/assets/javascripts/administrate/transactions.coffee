# Javascript for reports pages - transactions
$(document).ready ->
  do ->
    $('#vendor_start_date').datepicker()
    $('#vendor_end_date').datepicker()

    $('#exportTransactions').on 'click', ->
      vendorStartDate = $('#vendor_start_date').val()
      vendorEndDate = $('#vendor_end_date').val()
      vendorIds = $('#vendor_ids').val()
      if (vendorStartDate && vendorEndDate && vendorIds)
        $.ajax
          type: 'GET'
          url: '/admin/reports/export_transactions.xlsx'
          data: { vendor: { start_date: vendorStartDate, end_date: vendorEndDate, ids: vendorIds } }
          success: ->
            console.log('Xlsx file is exported')
          error: (error) ->
            console.log(error)
      else
        alert('Please enter values before applying filter')
