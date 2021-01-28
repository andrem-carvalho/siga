package br.gov.jfrj.siga.api.v1;

import java.nio.charset.StandardCharsets;
import java.util.Base64;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONObject;

import com.crivano.swaggerservlet.PresentableUnloggedException;
import com.crivano.swaggerservlet.SwaggerServlet;

import br.gov.jfrj.siga.Service;
import br.gov.jfrj.siga.api.v1.ISigaApiV1.AutenticarPostRequest;
import br.gov.jfrj.siga.api.v1.ISigaApiV1.AutenticarPostResponse;
import br.gov.jfrj.siga.api.v1.ISigaApiV1.IAutenticarPost;
import br.gov.jfrj.siga.base.HttpRequestUtils;
import br.gov.jfrj.siga.base.SigaMessages;
import br.gov.jfrj.siga.cp.AbstractCpAcesso;
import br.gov.jfrj.siga.cp.CpIdentidade;
import br.gov.jfrj.siga.cp.bl.Cp;
import br.gov.jfrj.siga.dp.dao.CpDao;
import br.gov.jfrj.siga.gi.service.GiService;
import br.gov.jfrj.siga.idp.jwt.SigaJwtBL;

@AcessoPublico
public class AutenticarPost implements IAutenticarPost {
	@Override
	public void run(AutenticarPostRequest req, AutenticarPostResponse resp) throws Exception {
		try (ApiContext ctx = new ApiContext(true, false)) {
			HttpServletRequest request = SwaggerServlet.getHttpServletRequest();

			final String authorization = request.getHeader("Authorization");
			if (authorization == null || !authorization.toLowerCase().startsWith("basic"))
				throw new Exception("Header Authorization deve conter uma autorização do tipo Basic");
			String base64Credentials = authorization.substring("Basic".length()).trim();
			byte[] credDecoded = Base64.getDecoder().decode(base64Credentials);
			String credentials = new String(credDecoded, StandardCharsets.UTF_8);
			final String[] values = credentials.split(":", 2);

			String username = values[0];
			String password = values[1];

			GiService giService = Service.getGiService();
			String usuarioLogado = giService.login(username, password);

			if (Pattern.matches("\\d+", username) && username.length() == 11) {
				List<CpIdentidade> lista = new CpDao().consultaIdentidadesCadastrante(username, Boolean.TRUE);
				if (lista.size() > 1) {
					throw new RuntimeException("Pessoa com mais de um usuário, favor efetuar login com a matrícula!");
				}
			}
			if (usuarioLogado == null || usuarioLogado.trim().length() == 0) {
				StringBuffer mensagem = new StringBuffer();
				mensagem.append(SigaMessages.getMessage("usuario.falhaautenticacao"));
				if (giService.buscarModoAutenticacao(username).equals(GiService._MODO_AUTENTICACAO_LDAP)) {
					mensagem.append(" ");
					mensagem.append(SigaMessages.getMessage("usuario.autenticacaovialdap"));
				}

				throw new RuntimeException(mensagem.toString());
			}

			String modulo = SigaJwtBL.extrairModulo(request);
			SigaJwtBL jwtBL = SigaJwtBL.inicializarJwtBL(modulo);
			Map <String, Object> mapClaim = new HashMap <String, Object>();
			mapClaim.put("podeAcessoWeb", new JSONObject(usuarioLogado)
					.getString("podeAcessoWeb").toString());
			
			String token = jwtBL.criarToken(username, null, mapClaim , null);

			Map<String, Object> decodedToken = jwtBL.validarToken(token);
			Cp.getInstance().getBL().logAcesso(AbstractCpAcesso.CpTipoAcessoEnum.AUTENTICACAO,
					(String) decodedToken.get("sub"), (Integer) decodedToken.get("iat"),
					(Integer) decodedToken.get("exp"), HttpRequestUtils.getIpAudit(request));

			resp.token = token;
		} catch (Throwable ex) {
			throw new PresentableUnloggedException("Erro no login: " + ex.getMessage(), ex);
		}
	}

	@Override
	public String getContext() {
		return "autenticar usuário";
	}

}
