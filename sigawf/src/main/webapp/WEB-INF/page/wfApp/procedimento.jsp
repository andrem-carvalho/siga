<%@ include file="/WEB-INF/page/include.jsp"%>
<siga:pagina titulo="${pi.sigla}">


	<div class="container-fluid content" id="page">

		<div class="row mt-2">
			<div class="col col-sm-12 col-md-8">
				<c:if
					test="${not f:podeUtilizarServicoPorConfiguracao(titular,lotaTitular,'SIGA;GC')}">
					<div id="desc_editar" style="display: none;">
						<h3>Descrição da Tarefa</h3>
						<div class="gt-form gt-content-box">
							<form method="POST"
								action="${linkTo[WfAppController].saveKnowledge}">
								<input name="tiId" type="hidden" value="${tiId}" />
								<div class="gt-form-row gt-width-100">
									<label>Descrição</label>
									<textarea cols="80" rows="15" name="conhecimento"
										class="gt-form-textarea">${task.conhecimento}</textarea>
								</div>
								<div class="gt-form-row gt-width-100">
									<input name="salvar_conhecimento" type="submit" value="Salvar"
										class="gt-btn-medium gt-btn-left" /> <a
										href="javascript: window.location.reload()"
										class="gt-btn-medium gt-btn-left">Cancelar</a>
								</div>
							</form>
						</div>
					</div>
				</c:if>

				<!-- Adicionando a lista de Tarefas -->
				<h2 class="mt-3">Procedimento ${pi.sigla}</h2>
				<siga:links>
					<c:forEach var="acao" items="${task.acoes}">
						<siga:link icon="${acao.icone}" title="${acao.nomeNbsp}"
							pre="${acao.pre}" pos="${acao.pos}"
							url="${pageContext.request.contextPath}${acao.url}"
							test="${true}" popup="${acao.popup}"
							confirm="${acao.msgConfirmacao}" classe="${acao.classe}"
							estilo="line-height: 160% !important" atalho="${true}"
							modal="${acao.modal}" />
					</c:forEach>
				</siga:links>

				<c:if test="${not empty task.definicaoDeTarefa}">
					<div class="card bg-info mb-3 mt-3">
						<div class="card-header text-white">
							<c:if test="${pi.tipoDePrincipal eq 'DOC'}">
								<a style="color: white; text-decoration: underline;"
									href="/sigaex/app/expediente/doc/exibir?sigla=${pi.principal}">${pi.principal}</a>
									- 
							</c:if>${task.nomeDoProcedimento}
							- ${task.nomeDaTarefa}
						</div>
						<div class="card-body bg-light text-black">

							<form method="POST"
								action="${linkTo[WfAppController].continuar(piId, null, null, null)}">
								<%@ include file="inc-form.jsp"%>
							</form>
						</div>
					</div>
				</c:if>

				<!-- Movimentações -->
				<c:if test="${not empty movs}">
					<div class="gt-content-box gt-for-table"
						style="margin-bottom: 25px; margin-top: 10px;">
						<script type="text/javascript">
							var css = "<style>TABLE.mov TR.despacho { background-color: rgb(240, 255, 240);}";
							css += "TABLE.mov TR.juntada,TR.desentranhamento { background-color: rgb(229, 240, 255);}";
							css += "TABLE.mov TR.anotacao { background-color: rgb(255, 255, 255);}";
							css += "TABLE.mov TR.anexacao { background-color: rgb(255, 255, 215);}";
							css += "TABLE.mov TR.encerramento_volume { background-color: rgb(255, 218, 218);}</style>";
							$(css).appendTo("head");
						</script>
						<table class="table table-sm table-responsive-sm table-striped">
							<thead>
								<tr>
									<th align="center">Tempo</th>
									<th>Lotação</th>
									<th>Evento</th>
									<th>Descrição</th>
									<th></th>
								</tr>
							</thead>
							<c:forEach var="mov" items="${movs}">
								<tr class="${mov.classeVO}">
									<td class="align-top" title="${mov.dtIniVO}">${mov.tempoRelativoVO}</td>
									<td class="align-top"
										title="${mov.hisIdcIni.dpPessoa.descricao} - ${mov.hisIdcIni.dpPessoa.lotacao.descricao}">${mov.lotaTitular.sigla}</td>
									<td class="align-top">${mov.evento}</td>
									<td class="align-top" style="word-break: break-all;"><span
										class="align-top">${mov.descricaoEvento}</span></td>

									<td class="align-top" style="word-break: break-all;"><span
										class="align-top"> <siga:links buttons="${false}"
												inline="${true}" separator="${false}">
												<c:forEach var="acao" items="${mov.acoes}">
													<siga:link title="${acao.nomeNbsp}" pre="${acao.pre}"
														pos="${acao.pos}"
														url="${pageContext.request.contextPath}${acao.url}"
														test="${true}" popup="${acao.popup}"
														confirm="${acao.msgConfirmacao}" classe="${acao.classe}"
														explicacao="${acao.explicacao}" post="${acao.post}" />
												</c:forEach>
											</siga:links>
									</span></td>

								</tr>
							</c:forEach>
						</table>
					</div>
				</c:if>
			</div>

			<div class="col col-sm-12 col-md-4">
				<c:if test="${not empty dot}">
					<div class="card-sidebar card bg-light mb-3">
						<div class="card-header">Diagrama</div>
						<a href="javascript:void(0)" href="javascript:void(0)"
							style="text-decoration: none">
							<div id="output" class="bg-light"
								style="border: 0px; padding: 0px; text-align: center;"></div>
						</a>
					</div>
					<!-- Fim mapa tramitação -->
				</c:if>

				<div class="card-sidebar card bg-light mb-3">
					<div class="card-header">Dados da Tarefa</div>
					<div class="card-body">
						<p>
							<b>Procedimento:</b> ${task.nomeDoProcedimento}
						</p>
						<p>
							<b>Tarefa:</b> ${task.nomeDaTarefa}
						</p>
						<p>
							<b>Prioridade:</b> ${task.prioridade.descr}
						</p>
						<p>
							<b>Cadastrante:</b> ${task.cadastrante} (${task.lotaCadastrante})
						</p>
						<p>
							<b>Titular:</b> ${task.titular} (${task.lotaTitular})
						</p>
						<p>
							<b>Início:</b> ${f:espera(task.inicio)}
						</p>
					</div>
					<div class="gt-sidebar"></div>
				</div>
			</div>

			<div class="gt-bd clearfix" style="display: none" id="svg">
				<div class="gt-content clearfix">
					<div id="desc_editar">
						<h3>Mapa do Procedimento</h3>
						<div style="display: none" id="input2">digraph G {
							graph[size="100,100", rankdir="LR"]; ${dot} }</div>

						<div class="gt-form gt-content-box" style="padding-bottom: 15px;"
							id="output2"></div>
					</div>
				</div>
				<a href="javascript: hideBig();" class="gt-btn-large gt-btn-left">Voltar</a>

			</div>

			<c:if
				test="${f:podeUtilizarServicoPorConfiguracao(titular,lotaTitular,'SIGA;GC')}">

				<c:url var="url" value="/../sigagc/app/knowledgeInplace">
					<c:param name="tags">${task.ancora}</c:param>
					<c:param name="msgvazio">Ainda não existe uma descrição de como esta tarefa deve ser executada. Por favor, clique <a
							href="$1">aqui</a> para contribuir.</c:param>
					<c:param name="titulo">${task.nomeDoProcedimento} - ${task.nomeDaTarefa}</c:param>
					<c:param name="ts">${currentTimeMillis}</c:param>
				</c:url>
				<script type="text/javascript">
			SetInnerHTMLFromAjaxResponse("${url}", document
					.getElementById('gc-ancora'));
		</script>

				<c:url var="url" value="/../sigagc/app/knowledgeSidebar">
					<c:param name="tags">@workflow</c:param>
					<c:forEach var="tag" items="${task.tags}">
						<c:param name="tags">${tag}</c:param>
					</c:forEach>
					<c:param name="ts">${currentTimeMillis}</c:param>
				</c:url>
				<script type="text/javascript">
			SetInnerHTMLFromAjaxResponse("${url}", document
					.getElementById('gc'));
		</script>
			</c:if>

			<%@ include file="anotar.jsp"%>

			<script>
		if (${not empty f:resource('graphviz.url')}) {
		} else if (window.Worker) {
			window.VizWorker = new Worker("/siga/javascript/viz.js");
			window.VizWorker.onmessage = function(oEvent) {
				document.getElementById(oEvent.data.id).innerHTML = oEvent.data.svg;
				$(document).ready(function() {
					updateContainer();
				});
			};
		} else {
			document
					.write("<script src='/siga/javascript/viz.js' language='JavaScript1.1' type='text/javascript'>"
							+ "<"+"/script>");
		}
	</script>
			<script>
		function buildSvg(id, input, cont) {
			if (${not empty f:resource('graphviz.url')}) {
			    input = input.replace(/fontsize=\d+/gm, "");
			    $.ajax({
				    url: "/siga/public/app/graphviz/svg",
				    data: input,
				    type: 'POST',
				    processData: false,
				    contentType: 'text/vnd.graphviz',
				    contents: window.String,
				    success: function(data) {
					    data = data.replace(/width="\d+pt" height="\d+pt"/gm, "");
					    data = data.replace(/fill="white"/gm, 'fill="none"');
					    data = data.replace(/stroke="white"/gm, 'stroke="none"');
					    $(data).width("100%");
				        $("#" + id).html(data);
				        updateContainer();
				    }
				});
			} else if (window.VizWorker) {
				document.getElementById(id).innerHTML = "Aguarde...";
				window.VizWorker.postMessage({
					id : id,
					graph : input
				});
			} else {
				var result = Viz(input, "svg", "dot");
				document.getElementById(id).innerHTML = result;
				cont();
			}
		}

		function bigmap() {
			var input = 'digraph G { graph[size="100,100"]; ${dot} }';
			buildSvg('output2', input, updateContainer);
		}

		function smallmap() {
			var input = 'digraph G { graph[size="3,3"]; ${dot} }';
			buildSvg('output', input, updateContainer);
		}

		function showBig() {
			document.getElementById('page').style.display = 'none';
			document.getElementById('svg').style.display = 'block';
			bigmap();
		}

		function hideBig() {
			document.getElementById('page').style.display = 'block';
			document.getElementById('svg').style.display = 'none';
			updateContainer();
		}

		smallmap();

		$(document).ready(function() {
			updateContainer();
			$(window).resize(function() {
				updateContainer();
			});
		});
		function updateContainer() {
			var smallwidth = $('#output').width();
			var smallheight = $('#output').height();
			var smallsvg = $('#output :first-child').first();
			var smallviewbox = smallsvg.attr('viewBox');
			
			if (smallheight > smallwidth * 4/4)
				smallheight = smallwidth * 4/4;

			if (smallsvg && smallsvg[0] && smallsvg[0].viewBox && smallsvg[0].viewBox.baseVal){

				console.log('updated')

				var baseVal = smallsvg[0].viewBox.baseVal;
				var width = smallwidth;
				var height = smallwidth * baseVal.height / baseVal.width;
				if (height > smallheight) {
					width = width * smallheight / height;
					height = smallheight;
				}
				smallsvg.attr('width', width);
				smallsvg.attr('height', height);
			} else if (typeof smallviewbox != 'undefined') {
				var a = smallviewbox.split(' ');
				
				// set attrs and 'resume' force 
				smallsvg.attr('width', smallwidth);
				smallsvg.attr('height', smallwidth * a[3] / a[2]);
			} 

			var bigwidth = $('#output2').width();
			var bigsvg = $('#output2 :first-child').first();
			var bigviewbox = bigsvg.attr('viewBox');

			if (typeof bigviewbox != 'undefined') {
				var a = bigviewbox.split(' ');

				// set attrs and 'resume' force 
				bigsvg.attr('width', bigwidth);
				bigsvg.attr('height', bigwidth * a[3] / a[2]);
			}
		}
	</script>
</siga:pagina>