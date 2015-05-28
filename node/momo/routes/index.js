var app = require('../app') ;

app.set('sections',  {
	momoko:{
		title:'大きめの鯛',
		desc:'銅版画',
		copy:'&copy; 2010 - 2012',
		jp:{
			firstname:'桃子',
			lastname:'長谷'
		},
		en:{
			firstname:'MOMOKO',
			lastname:'NAGATANI'
		},
		mail:'momokonagatani@gmail.com'
	},
	ookimenotai:{
		desc:'The Rather Big Carp',
		dimensions:'20x20',
		jp:{
			title:'大きめの鯛',
			year:'二〇十一',
			technique:'銅版画'
		},
		en:{
			title:'OOKIMENOTAI',
			year:'2011',
			technique:'prints on paper'
		},
		slides:[
			{
				name:'tai1',
				texts:[
					'供花にしたるも春とどきしか',
					'桜木に詫びて手折りし花一枝'
				]
			},
			{
				name:'tai2',
				texts:[
					'超名人と吾は呼びおる',
					'百キロの筍掘り取る夫なれば'
				]
			},
			{
				name:'tai3',
				texts:[					
					'ぜんざい煮えて外は粉雪',
					'手近なる幸せだよと夫が言ふ'
				]
			},
			{
				name:'tai4',
				texts:[
					'鯛で祝ふと甘煮にしたり',
					'待ちわびし孫の帰国に大きめの'
				]
			},
			{
				name:'tai5',
				texts:[
					'名残の花びら肩にかかりぬ',
					'葉桜の息吹もらいに佇めば'
				]
			}
		]
	},
	cactus:{
		desc:'Lizards & Sunshine',
		dimensions:'10x10',
		jp:{
			title:'サボテンと',
			year:'二〇十一',
			technique:'銅版画'
		},
		en:{
			title:'CACTUS',
			year:'2011',
			technique:'prints on paper'
		},
		slides:[
			{name:'momo1'},
			{name:'momo2'},
			{name:'momo3'},
			{name:'momo4'},
			{name:'momo5'}
		]
	},
	trump:{
		desc:'Printed Card Games',
		dimensions:'20x40',
		jp:{
			title:'トランプ',
			year:'二〇十一',
			technique:'銅版画'
		},
		en:{
			title:'TRUMP',
			year:'2011',
			technique:'prints on paper'
		},
		slides:[
			{name:'trump1'},
			{name:'trump2'},
			{name:'trump3'},
			{name:'trump4'}
		]
	},
	nekodearu:{
		desc:'I am a Cat',
		dimensions:'30x40',
		jp:{
			title:'猫である',
			year:'二〇十一',
			technique:'銅版画'
		},
		en:{
			title:'NEKO DEARU',
			year:'2011',
			technique:'prints on paper'
		},
		slides:[
			{name:'neko1'},
			{name:'neko2'},
			{name:'neko3'}
		]
	}
 }) ;

exports.index = function(req, res){
  res.render('index', { title: 'OOKIMENOTAI :::::: Momoko NAGATANI :::::: Prints on Paper' , sections: app.get('sections')});
};