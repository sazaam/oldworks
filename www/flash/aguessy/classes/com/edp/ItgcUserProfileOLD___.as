package com.edp 
{
	
	/**
	 * ...
	 * @author David OSTERMANN
	 */
	public class ItgcUserProfile 
	{

		/** guid (Documentation says: "Optional") */
		public var UserId:String;

		/** int (Documentation says: "Optional") */
		public var IdConsumerView:int;

		/** string */
		public var Email:String;

		/** string */
		public var Password:String;

		/** MRS or MISS or MR (REQUIRED: minOccurs="1" AND nillable="false") */
		public var Title:String;

		/** string */
		public var FirstName:String;

		/** string */
		public var LastName:String;

		/** dateTime (REQUIRED: minOccurs="1" AND nillable="false") */
		/** David SIXANDCO : exemple aaaa-mm-dd */
		public var DateOfBirth:String;

		/** Male or Female (REQUIRED: minOccurs="1" AND nillable="false") */
		public var Gender:String;

		/** string */
		public var Address:String;

		/** string */
		public var Town:String;

		/** string */
		public var ZipCode:String;

		/** string */
		public var Phone:String;

		/** string */
		public var MobilePhone:String;

		/** France (REQUIRED: minOccurs="1" AND nillable="false") */
		public var Country:String = "France";

		/** int (REQUIRED: minOccurs="1" AND nillable="false") */
		public var Under25ChildrenCount:int;

		/** int (REQUIRED: minOccurs="1" AND nillable="false") */
		public var HouseholdMembersCount:int;

		/** boolean (REQUIRED: minOccurs="1" AND nillable="false") (Documentation says: "Subscription to the newsletter") */
		public var ProgramOpt:Boolean;

		/** boolean (REQUIRED: minOccurs="1" AND nillable="false") */
		public var SmsOpt:Boolean;

		/** string */
		public var SmsMobileNumber:String;

		/** Orange or SFR or Bouygues */
		public var SMSOperator:String;

		/** boolean */
		public var SmsWapCompatible:Boolean;

		/** boolean */
		public var SmsImodeCompatible:Boolean;

		/** boolean */
		public var SmsMmsCompatible:Boolean;

		/** boolean */
		public var Sms3GCompatible:Boolean;

		/** boolean */
		public var CorporateOpt:Boolean;

		/** boolean */
		public var PartnersOpt:Boolean;

		/** int */
		public var ProvenanceId:int;

		/** string */
		public var MaidenName:String;

		/** string */
		public var CivicNumber:String;

		/** boolean (REQUIRED: minOccurs="1" AND nillable="false") (Documentation says: "Default value: False.") */
		public var WidgetInstalled:Boolean;

		/** int (REQUIRED: minOccurs="1" AND nillable="false") */
		public var UserLevel:int;

		/** dateTime */
		/** David SIXANDCO : exemple aaaa-mm-dd */
		public var PartnerDateOfBirth:String;

		/** dateTime */
		/** David SIXANDCO : exemple aaaa-mm-dd */
		public var DueDate:String;

		/** dateTime */
		/** David SIXANDCO : exemple aaaa-mm-dd */
		public var Child1DateOfBirth:String;

		/** dateTime */
		/** David SIXANDCO : exemple aaaa-mm-dd */
		public var Child2DateOfBirth:String;

		/** dateTime */
		/** David SIXANDCO : exemple aaaa-mm-dd */
		public var Child3DateOfBirth:String;

		/** dateTime */
		/** David SIXANDCO : exemple aaaa-mm-dd */
		public var Child4DateOfBirth:String;

		/** string */
		public var Child1FirstName:String;

		/** string */
		public var Child2FirstName:String;

		/** string */
		public var Child3FirstName:String;

		/** string */
		public var Child4FirstName:String;

		/** Male or Female */
		public var Child1Gender:String;

		/** Male or Female */
		public var Child2Gender:String;

		/** Male or Female */
		public var Child3Gender:String;

		/** Male or Female */
		public var Child4Gender:String;

		/** boolean */
		public var Atac:Boolean;

		/** boolean */
		public var Franprix:Boolean;

		/** boolean */
		public var Intermarche:Boolean;

		/** boolean */
		public var Lidl:Boolean;

		/** boolean */
		public var Shopi:Boolean;

		/** boolean */
		public var HuitaHuit:Boolean;

		/** boolean */
		public var Auchan:Boolean;

		/** boolean */
		public var Continent:Boolean;

		/** boolean */
		public var Leclerc:Boolean;

		/** boolean */
		public var ComodStoc:Boolean;

		/** boolean */
		public var Champion:Boolean;

		/** boolean */
		public var Cora:Boolean;

		/** boolean */
		public var G20:Boolean;

		/** boolean */
		public var LeaderPrice:Boolean;

		/** boolean */
		public var Carrefour:Boolean;

		/** boolean */
		public var Geant:Boolean;

		/** boolean */
		public var Match:Boolean;

		/** boolean */
		public var Monoprix:Boolean;

		/** boolean */
		public var Casino:Boolean;

		/** boolean */
		public var Aldi:Boolean;

		/** boolean */
		public var HyperU:Boolean;

		/** boolean */
		public var SuperU:Boolean;

		/** boolean */
		public var Netto:Boolean;

		/** boolean */
		public var MagasinsDeQuartier:Boolean;

		/** boolean */
		public var Ed:Boolean;

		/** boolean */
		public var Houra:Boolean;

		/** boolean */
		public var Ooshop:Boolean;

		/** boolean */
		public var Telemarket:Boolean;

		/** boolean */
		public var AuchanDirect:Boolean;

		/** boolean */
		public var OtherSupermarket:Boolean;
		
		private var _arrProps:Object;
		
		public function get arrProps():Object
		{
			_arrProps = {};
			_arrProps.UserId = UserId ;
			
			_arrProps.IdConsumerView = IdConsumerView ;
			_arrProps.Email = Email ;
			_arrProps.Password = Password ;
			_arrProps.Title = Title ;
			_arrProps.FirstName = FirstName ;
			_arrProps.LastName = LastName ;
			_arrProps.DateOfBirth = DateOfBirth ;
			_arrProps.Address = Address ;
			_arrProps.Town = Town ;
			_arrProps.ZipCode = ZipCode ;
			_arrProps.Phone = Phone ;
			_arrProps.MobilePhone = MobilePhone ;
			_arrProps.Country = Country ;
			_arrProps.Under25ChildrenCount = Under25ChildrenCount ;
			_arrProps.HouseholdMembersCount = HouseholdMembersCount ;
			_arrProps.ProgramOpt = ProgramOpt ;
			_arrProps.SmsOpt = SmsOpt ;
			_arrProps.SmsMobileNumber = SmsMobileNumber ;
			_arrProps.SMSOperator = SMSOperator ;
			_arrProps.SmsWapCompatible = SmsWapCompatible ;
			_arrProps.SmsImodeCompatible = SmsImodeCompatible ;
			_arrProps.SmsMmsCompatible = SmsMmsCompatible ;
			_arrProps.Sms3GCompatible = Sms3GCompatible ;
			_arrProps.CorporateOpt = CorporateOpt ;
			_arrProps.ProvenanceId = ProvenanceId ;
			_arrProps.MaidenName = MaidenName ;
			_arrProps.CivicNumber = CivicNumber ;
			_arrProps.WidgetInstalled = WidgetInstalled ;
			_arrProps.UserLevel = UserLevel ;
			_arrProps.PartnerDateOfBirth = PartnerDateOfBirth ;
			_arrProps.DueDate = DueDate ;
			_arrProps.Child1DateOfBirth = Child1DateOfBirth ;
			_arrProps.Child2DateOfBirth = Child2DateOfBirth ;
			_arrProps.Child3DateOfBirth = Child3DateOfBirth ;
			_arrProps.Child4DateOfBirth = Child4DateOfBirth ;
			_arrProps.Child1FirstName = Child1FirstName ;
			_arrProps.Child2FirstName = Child2FirstName ;
			_arrProps.Child3FirstName = Child3FirstName ;
			_arrProps.Child4FirstName = Child4FirstName ;
			_arrProps.Atac = Atac ;
			_arrProps.Franprix = Franprix ;
			_arrProps.Intermarche = Intermarche ;
			_arrProps.Lidl = Lidl ;
			_arrProps.Shopi = Shopi ;
			_arrProps.HuitaHuit = HuitaHuit ;
			_arrProps.Auchan = Auchan ;
			_arrProps.Continent = Continent ;
			_arrProps.Leclerc = Leclerc ;
			_arrProps.ComodStoc = ComodStoc ;
			_arrProps.Champion = Champion ;
			_arrProps.Cora = Cora ;
			_arrProps.G20 = G20 ;
			_arrProps.LeaderPrice = LeaderPrice ;
			_arrProps.Carrefour = Carrefour ;
			_arrProps.Geant = Geant ;
			_arrProps.Match = Match ;
			_arrProps.Casino = Casino ;
			_arrProps.Aldi = Aldi ;
			_arrProps.HyperU = HyperU ;
			_arrProps.SuperU = SuperU ;
			_arrProps.Netto = Netto ;
			_arrProps.MagasinsDeQuartier = MagasinsDeQuartier ;
			_arrProps.Ed = Ed ;
			_arrProps.Houra = Houra ;
			_arrProps.Ooshop = Ooshop ;
			_arrProps.Telemarket = Telemarket ;
			_arrProps.AuchanDirect = AuchanDirect ;
			_arrProps.OtherSupermarket = OtherSupermarket ;
			
			return _arrProps ;
			
			
		}

		
	}
	
}