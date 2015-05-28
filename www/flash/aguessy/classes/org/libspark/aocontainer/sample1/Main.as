package org.libspark.aocontainer.sample1
{
    import org.libspark.aocontainer.AOContainer;
    import org.libspark.aocontainer.AOContainerFactory;
	import org.libspark.aocontainer.AllTests;
    
    public class Main
    {
        public function Main()
        {
            HogeImpl; FugaA; FugaB;
            
            var config:XML =
                <objects>
                    <object name='ha' class='org.libspark.aocontainer.sample1.HogeImpl'>
                        <object class='org.libspark.aocontainer.sample1.FugaA'/>
                    </object>
                    <object name='hb' class='org.libspark.aocontainer.sample1.HogeImpl'>
                        <object class='org.libspark.aocontainer.sample1.FugaB'/>
                    </object>
                </objects>
            
            var container:AOContainer = AOContainerFactory.create(config);
			
            var ha:Hoge = Hoge(container.getObject('ha'));
            ha.process();
            var hb:Hoge = Hoge(container.getObject('hb'));
            hb.process();
			
        }
    }
}