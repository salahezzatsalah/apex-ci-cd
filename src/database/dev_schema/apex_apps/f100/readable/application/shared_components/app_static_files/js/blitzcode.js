 apex.jQuery( document ).ready( function() {
 
    // Action to open search dialog
    apex.actions.add( {
        name: 'open-search',
        label: 'Open Search',
        action: function( event, focusElement, args ) {
            const RESULT_TYPE = args?.RESULT_TYPE;
            apex.items.P0_SEARCH.setValue( RESULT_TYPE );
            apex.theme.openRegion( 'SearchDialog' );
            apex.regions.SearchData.refresh();
            apex.jQuery( '.t-DialogRegion-bodyWrapperOut' ).scrollTop( 0 );
            
            setTimeout( () => {
                apex.items.P0_SEARCH.setFocus();
            }, 100 );
        }
    } );

} );