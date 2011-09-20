(function( $ ){
    var yottaa = window.yottaa = window.yottaa || {};
    
    $.extend( yottaa, {
        contains: function(parent, child){
            return document.compareDocumentPosition ?
                        parent.compareDocumentPosition( child ) & 16 :
                        parent !== child && parent.contains( child );
        },
        module: function(name){
            return yottaa.module.modules[name];
        }
    });
    
    //yottaa module loader extention
    $.extend( yottaa.module, {
        initialize: function(){
            var loader = yottaa.module,
                modules = loader.modules;
            
            //find module references
            $(function(){
                var includedModules = [];
                $('cite').each( function( i, e){
                    e = $(e);
                    if( e.attr('data-name') == 'module' && $.inArray( e.attr('data-value'), includedModules ) == -1 && modules[e.attr('data-value')] ){
                        modules[e.attr('data-value')].init();
                    }
                });
            });
        },
        
        create: function( name, options){
            yottaa.module.modules[ name ] = options;
        },
        
        get: yottaa.module,
        
        modules: {}
    });
})( jQuery );


//basic modules
(function($){
    var yottaa = window.yottaa;
    
    //datePickers module
    yottaa.module.create( 'datePickers', {
        init: function(){
            var self = this,
                picker = self.target = $("div.date_pickers"),
                dates = $('span[name="date"]', picker),
                uiDates = self._uiDates = { start:  dates.filter('[value=start]').find('label'), end: dates.filter('[value=end]').find('label') }, 
                i, length, opt;

            dates.click( function(){
                if( picker.hasClass('qtip') ){
                    self.hidePicker();
                }
                else{
                    self.showPicker();
                }
            });

            $(document).click(function(event){
                if( $(event.target).parents().andSelf().index(picker) == -1 && !$(event.target).parents('.ui-datepicker-header, .ui-datepicker-calendar').length ){
                    self.hidePicker(true);
                }
            });

            $('.date_picker', picker).each( function(){
        	    var onePicker = $(this), type = onePicker.attr('date_for');
        	    onePicker.datepicker({
        			inline: true,
        			maxDate: "+0M +0D",
        			dateFormat: "mm/dd/yy",
        			defaultDate: dates.filter( '[value=' + type + ']' ).find('label').text(),
        			onSelect: function(dateText, inst){
        			    dates.filter( '[value=' + onePicker.attr('date_for') + ']' ).find('label').text(dateText);
        			}
        		});
        	});

        	$('a[rel="cancel"]', picker).click(function(){
        	    for( i = 0, length = self.cancelCallbacks.length; i < length; i++ ){
        	        opt = self.cancelCallbacks[i];
        	        opt && opt.callback.call( opt.context );
        	    }
        	    self.hidePicker(true);
        	});

        	$('a[rel="update"]', picker).click(function(){
        	    for( i = 0, length = self.updateCallbacks.length; i < length; i++ ){
        	        opt = self.updateCallbacks[i];
        	        opt && opt.callback.call( opt.context );
        	    }
        	    self.hidePicker();
        	});

        	//date quick sets
        	$('li.quick_date a', picker).click( function(){
        	    var setter = $(this),
        	        dsSet = setter.attr('date_start'),
        	        deSet = setter.attr('date_end');

        	    dsSet = self._dateFrom( dsSet );
        	    deSet = self._dateFrom( deSet );

                dates.filter( '[value="start"]' ).find('label').text( dsSet );
                dates.filter( '[value="end"]' ).find('label').text( deSet );

                $('.date_picker[date_for="start"]', picker).datepicker('setDate', dsSet);
                $('.date_picker[date_for="end"]', picker).datepicker('setDate', deSet);
        	});
        },
        
        getDates: function( startName, endName ){
            var d = {};
                d[ startName || 'start' ] = this._uiDates['start'].text();
                d[ endName || 'end' ] = this._uiDates['end'].text();
            return d;
        },
        
        associateCancel: function( opt ){
            if( $.isFunction( opt ) ){
                opt = {
                    context: this,
                    callback: opt
                }
            }
            
            this.cancelCallbacks.push( opt );
        },
        
        associateUpdate: function( opt ){
            if( $.isFunction( opt ) ){
                opt = {
                    context: this,
                    callback: opt
                }
            }
            
            this.updateCallbacks.push( opt );
        },

        _dateFrom: function(dateStr){
            var dateRet = null, now = new Date(), tmpDate;

    	    if( !dateStr ){  
    	        dateRet = Yottaa.lib.formatDate( now, "%m/%d/%Y" ); 
    	    }
    	    else{
    	        var dateArray = [ now.getUTCDate(), now.getUTCMonth(), now.getUTCFullYear() ],
    	            setIndex = 0, i;
    	        dateStr = dateStr.split(" ");
    	        for( i = dateStr.length - 1; i >= 0; i--, setIndex++ ){
    	            if(/{[-\d]+}/.test(dateStr[i])){
    	                dateArray[setIndex] = parseInt( dateStr[i].replace(/{|}/g, "" ) );
    	            }
    	            else{
    	                dateArray[setIndex] += parseInt( dateStr[i] );
    	            }
    	        }
    	        tmpDate = new Date();
    	        tmpDate.setUTCFullYear(dateArray[2]);
    	        tmpDate.setUTCMonth(dateArray[1]);
    	        tmpDate.setUTCDate(dateArray[0]);
    	        dateRet = Yottaa.lib.formatDate( tmpDate, "%m/%d/%Y" ); 
    	    }
    	    return dateRet;
        },

        showPicker: function(){
            this.target.addClass('qtip drop_shadow');

            //save the status
            this.savedStatus = { start: this._uiDates['start'].text(), end: this._uiDates['end'].text() };
        },

        hidePicker: function(reset){
            this.target.removeClass('qtip drop_shadow');
            if( reset && this.savedStatus ){
                this._uiDates['start'].text( this.savedStatus.start );
                this._uiDates['end'].text( this.savedStatus.end );
            }
            this.savedStatus = null;
        },

        updateCallbacks: [],
        cancelCallbacks: [],
        savedStatus: null,
        target: null
    });
    
    //timestamp module
    yottaa.module.create( 'timestampPicker', {
       init: function(){
           var self = this;
           $('.timestamp_picker').each( function(){
               self.bindHandlerFor( this );
               self.bindArrowsHandler( this );
           });
       },
       
       resetPointsFor: function( picker, timePoints, selected ){
           var self = this,
                wrapper = picker.find('ul').empty();
            
            picker = $(picker);
            selected = selected || timePoints[0];
                
           for( var i = 0, length = timePoints.length; i < length; i++ ){
               $('<li class="timestamp corner_all_3 inline_block"></li>')
                    .addClass( timePoints[i] == selected ? "selected" : '' )
                    .attr( 'date-stamp', timePoints[i] )
                    .appendTo( wrapper )
                    .html( Yottaa.lib.formatToCharDate( timePoints[i] ) );
           }
           
           if( wrapper.width() <= picker.width() ){
               picker.find('.previous, .next').hide();
           }
           else{
               picker.find('.previous, .next').show();
           }
           
           self.bindHandlerFor( picker );
           //self.bindArrowsHandler( picker );
           self.bindArrowsHandler_move( picker );
       },
       
       bindHandlerFor: function( picker ){
           picker = $(picker);
           picker.find('li.timestamp').click(function(){
              if( $(this).hasClass('selected')){ return false; }
              $(this).addClass( 'selected' ).siblings('.selected').removeClass('selected');
              picker.trigger( 'timestampChanged', [ $(this).attr('date-stamp') ] );
           });
       },
       
       bindArrowsHandler_move: function(picker){
            picker = $(picker);
            var wrapper = picker.find('ul').css('left', 0),
                prev = picker.find('.previous'),
                next = picker.find('.next'),
                tw = $(picker).width();
            
            prev.mouseover( function(){
               var iw = wrapper.width(),
                    l = Math.abs(parseInt( wrapper.css('left') ));
                    wrapper.animate( { left: 0 } ,l*10,'swing');               
            });
            prev.mouseout( function(){
                    wrapper.stop();     
            });                       
            next.mouseover( function(){
               var iw = wrapper.width(),
                    l = parseInt( wrapper.css('left') );
                    wrapper.animate( { left: tw-iw-10 },-(tw-iw-10-l)*10,'swing');             
            });
            next.mouseout( function(){
                    wrapper.stop();     
            });
       },
       bindArrowsHandler: function(picker){
            picker = $(picker);
            var wrapper = picker.find('ul').css('left', 0),
                prev = picker.find('.previous'),
                next = picker.find('.next'),
                tw = $(picker).width();
            
            prev.unbind('click').click( function(){
               var iw = wrapper.width(),
                    l = parseInt( wrapper.css('left') ),
                    dl = Math.min( l + 80, 0);
                if( dl > l ){
                    wrapper.animate( { left: dl } );
                }
            });
            
            
            next.unbind('click').click( function(){
               var iw = wrapper.width(),
                    l = parseInt( wrapper.css('left') ),
                    dl = iw > tw ? Math.max( l - 80, tw - iw) : 0;
                if( dl < l ){
                    wrapper.animate( { left: dl } );
                }
            });
       }       
    });
    
    
    //switcher module
    yottaa.module.create( "switcher", {
        init: function(){
            var switchers = $('.switcher');
            
            switchers.filter('.expandable').each(function(){
                var switcher = $(this);
                switcher.find('.guide').click(function(){
                   switcher.toggleClass('expanded drop_shadow'); 
                });
            });
            
            $(document).click(function(event){
                if( switchers.filter('.expanded').length ){
                    var switcher = switchers.filter('.expanded').first();
                    if( $(event.target).parents().andSelf().index( switcher ) == -1 ){
                        switcher.removeClass('expanded drop_shadow'); 
                    }
                }
            });
            
            switchers.filter('.expandable.using_ajax').find( 'li > a' ).click(function(){
                var item = $(this).parents('li'),
                    switcher = item.parents('.switcher'),
                    selected = item.attr('data_value'),
                    previous = switcher.attr('data_value');
                    
                    if( selected != previous ){
                        switcher.removeClass('expanded drop_shadow');
                        switcher.attr('data_value', selected );
                        switcher.trigger('switcherChange', [ item.attr('data_value'), switcher.attr('data_base') ] );
                    }
                
                return false;
            });
            
            switchers.each(function(){
                var switcher = $(this);
                if(switcher.hasClass('auto_load')){
                    setTimeout(function(){switcher.trigger('switcherChange', [ switcher.attr('data_value'), switcher.attr('data_base') ] );}, 100); //delay 100 millisecond to execute
                }
            });
        }
    });
})(jQuery);

//call yottaa module initializer
(function($){
    yottaa.module.initialize();
})(jQuery);