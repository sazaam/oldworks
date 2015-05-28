/*
 * Shinobi - a OOP based kit. The
 * original source remains:
 *
 * Copyright (c) 2012, Shinobi
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or
 * without modification, are permitted provided that the following
 * conditions are met:
 *
 *  * Redistributions of source code must retain the above
 *    copyright notice, this list of conditions and the
 *    following disclaimer.
 *  * Redistributions in binary form must reproduce the above
 *    copyright notice, this list of conditions and the following
 *    disclaimer in the documentation and/or other materials provided
 *    with the distribution.
 *  * Neither the name of the Shinobi Software nor the names of
 *    its contributors may be used to endorse or promote products
 *    derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
 * CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
 * BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY,
 * OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
 * OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
 * TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
 * OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY
 * OF SUCH DAMAGE.
 */
(function Shinobi(namespace) {
	
	return package_("*", function context(global) {
		
		shinobi.ipath("js/modules/");
			
		var Linker = include_("shinobi.Linker");
		var Class = include_("shinobi.Class");
		var System = include_("shinobi.System");
		var trace = include_("trace");
		var Xapp = include_("xapp");
		
		return class_({
			qname : "Main",
			subclass : {
				constructor : function Main() {
				},
				statics : {
					/**
					 * Main Shinobi method like
					 * 
					 * @param {Object} launcher
					 */
					main : function main(launcher) {
						//settings custom lauching function
						launcher.launch = function launch() {
							
							trace(arguments[0]);
							
							this.addEventListener(global, "load", Class.bind(this, function onLoad() {							
								
								this.removeEventListener(global, "load", onLoad);
								
								this.app = new XApp({
									'root':'./js/',
									'modulespath':'./modules/',
									'apps':[
										{name:'all', url:'./all.js'}
									]
								});
								
								trace(this.app);
								
							}));
							
						};
						launcher.launch("Main.main executed at " + (System.nanoTime() / 60) + " ns");						
					}
				}
			},
			namespace : global
		});
		
	}, namespace);

})(window);