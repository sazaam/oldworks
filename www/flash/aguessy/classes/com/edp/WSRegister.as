package com.edp
{
	
	import alducente.services.WebService;
	import alducente.services.CustomWebService;
	import flash.events.*;
	import flash.utils.getTimer;

	public class WSRegister
	{
		
		private var initTime: Number;
		private var ws: WebService;
		private var userProfile : Object ;
		
		public function WSRegister()
		{
			var url: String = "http://itgc.proximity.fr/webpartcollection/Fr.Procter.WebPartSubscription/WebServices/WS_Subscription_v2_1.asmx?WSDL";
			ws = new CustomWebService() ;
			ws.addEventListener(Event.CONNECT, connected) ;
			ws.connect(url) ;
			ws.cacheResults = true ;
		}
		
		public function connected (evt: Event): void
		{
			initTime = getTimer();
			
			userProfile = new Object();
			// Assemble the user object	
			userProfile.Email = "ostermann+user9@sixandco.com";
			userProfile.Password = "password";
			userProfile.Title = "MRS";
			userProfile.FirstName = "OStermann";
			userProfile.LastName = "DAvid";
			userProfile.DateOfBirth = "1976-10-22";
			userProfile.Gender = 'Male';
			userProfile.Town = "Paris";
			userProfile.ZipCode = "75017";
			userProfile.Address = " 3 rue Chezmoi";
			userProfile.ProgramOpt = false;
			userProfile.CorporateOpt = false;
			userProfile.PartnersOpt = false;
			
			userProfile.OtherSupermarket = true; // at least one supermarket is required, but not asked
			userProfile.Country = 'France'; // required, always France
			
			var formattedUserProfile : String = soapFormatUserProfile ;
			
			trace( formattedUserProfile );
			
			ws.CreateProfile(done, formattedUserProfile, "null", "92618B0D-7744-4DC2-975A-182E4B75B378" );
			
			var availableMethods : Array = ws.availableMethods ;
				
			//trace("// ws.availableMethods :: " );
			
			for( var m:* in availableMethods )
			{
				
				//trace( " \n\r--> METHODE N° ", m );
				
				for( var p:* in availableMethods[m] )
				{
				
					//trace( " ----> PARAM N° ", p , " :> ", availableMethods[m][p] );
				
				}
				
			}
		}
		
		public function done (response: XML): void
		{
			trace("\nWeb Service Result: ");
			var time: Number = getTimer();
			trace("Call duration: ", time - initTime, " milliseconds");
			initTime = time;
			trace(response);
		}
				
		protected function get soapFormatUserProfile():String
		{
			
			var str : String = "\r";
            str += "<Email><![CDATA["+userProfile.Email+"]]></Email>\r";
            str += "<Password>"+userProfile.Password+"</Password>\r";
            str += "<Title>"+userProfile.Title+"</Title>\r";
            str += "<FirstName>"+userProfile.FirstName+"</FirstName>\r";
            str += "<LastName>"+userProfile.LastName+"</LastName>\r";
            str += "<DateOfBirth>"+userProfile.DateOfBirth+"</DateOfBirth>\r";
            str += "<Gender>"+userProfile.Gender+"</Gender>\r";
            str += "<Address>"+userProfile.Address+"</Address>\r";
            str += "<Town>"+userProfile.Town+"</Town>\r";
            str += "<ZipCode>"+userProfile.ZipCode+"</ZipCode>\r";
            str += "<Country>"+userProfile.Country+"</Country>\r";
            str += "<ProgramOpt>" + userProfile.ProgramOpt + "</ProgramOpt>\r";
			str += "<CorporateOpt>" + userProfile.CorporateOpt + "</CorporateOpt>\r";
			str += "<PartnersOpt>" + userProfile.PartnersOpt + "</PartnersOpt>\r";
            str += "<OtherSupermarket>true</OtherSupermarket>\r";
			
			return str ;
			
		}

	}
	
}
