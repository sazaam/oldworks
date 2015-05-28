/* PAGE LOAD */
$(window).bind('load', function(e){
    $(window).unbind('load', arguments.callee) ;
   
    // Enable the hierarchy
    //window.hierarchy = new AddressHierarchy(Unique) ;
   
   
    var absolute1 = 'http://dark:13002/en/art-contemporain/55/publications/?question=0&page=1' ;
    var absolute2 = 'http://127.0.0.1/TESTSUITE/COUCOU/SARACE/#/en/12/home/4/saz/3/toto/' ;
    var absolute3 = '/TESTSUITE/#/en/12/home/4/saz/3/toto/' ;
	var absolute4 = '/en/' ;
    var url1 = new Address(absolute1) ;
    var url2 = new Address(absolute2) ;
    var url3 = new Address(absolute3) ;
    var url4 = new Address(absolute4) ;
    trace(url1)
    trace(url2)
    trace(url3)
    trace(url4)
    
    
    
}) ;



/* PAGE LOAD */
$(window).bind('load', function(e){
    $(window).unbind('load', arguments.callee) ;
    
    // Enable the hierarchy
    window.hierarchy = new AddressHierarchy(Unique) ;
}) ;
/* STEPS OF INNER SITE */
var HomeStep = NS('HomeStep', NS('pro::HomeStep', Step.$extend({
    __classvars__:{
        version:'0.0.1',
        toString:function()
        {
            return '[class HomeStep]' ;
        }
    },
    __init__:function(id, label)
    {
        this.$super(id, new Command(this, this.onStep), new Command(this, this.onStep, false)) ;
        this.label = label ;
    },
    onStep:function(cond){
        if (cond === undefined) cond = true ;
        var c = this ;
        var step = c.context ;
        
        var homePage = window.home ;
        
        if(cond){
            
            //homePage.appendTo('#all') ;
            setTimeout(function(){
                trace('step complete', step.label)
                c.dispatchComplete() ;
            }, 50) ; 
        }else{
            //homePage.remove() ;
            setTimeout(function(){
                trace('step complete', step.label)
                c.dispatchComplete() ;
            }, 50) ; 
        }
        return this ;
    },
    toString:function()
    {
        var st = this ;
        return '[HomeStep >>> id:'+ st.id+' , path: '+st.path +' , label: '+st.label + ' , ' + ((st.children.length > 0) ? '[\n'+st.dumpChildren() +'\n]'+ ']' : ']') ;
    }
}))) ;
/* STEPS DECLARATIONS */
var Unique = NS('Unique', NS('pro::Unique', Step.$extend({
    __classvars__:{
        version:'0.0.1',
        instance:undefined,
        getInstance:function(){ return Unique.instance || new Unique() },
        toString:function()
        {
            return '[class Unique]' ;
        }
    },
    __init__:function(loopables)
    {
        this.$super('fashion', new Command(this, this.onStep)) ;
        Unique.instance = this ;
        
        window.project = new Project() ;
        
        trace('UNIQUE INSTANCIATED...') ;
    },
    onStep:function(){
        trace('UNIQUE STEP OPENING') ;
        var c = this ;
        var u = c.context ;
        
        u.addSteps() ;
        
        setTimeout(function(){
            c.dispatchComplete() ;
        }, 50);
        
        return this ;
    },
    addSteps:function(){
        var st = this ;
        
        
        st.add(new HomeStep('home', 'home') ) ;
        st.add(new HomeStep('prout', 'prout') ) ;
        
        // treating .ajaxian nodes to retrieve links...
        
        
        trace('Steps shouls have been added...')
    },
    toString:function()
    {
        var st = this ;
        return '[Unique >>> id:'+ st.id+' , path: '+ st.path + ((st.children.length > 0) ? '[\n'+ st.dumpChildren() + '\n]' + ']' : ']') ;
    }
}))) ;


/* CUSTOM STEFFIE CHRISTIAENS HELPERS */
var Project = NS('Project', NS('pro::Project', Class.$extend({
    __classvars__:{
        version:'0.0.1',
        toString:function()
        {
            return '[class Project]' ;
        }
    },
    __init__:function()
    {
        trace('Project v.0.1') ;
    },
    activeContent:function(tt, step){
        
        trace('active Content with template >>>>', tt, step.labelPath) ;
        
    },
    toString:function()
    {
        return '[ object ' + this.$class.ns + ' v.'+this.$class.version +']';
    }
}))) ;