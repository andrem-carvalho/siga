package br.gov.jfrj.siga.wf;

import com.crivano.jflow.Task;
import com.crivano.jflow.model.TaskKind;
import com.crivano.jflow.task.TaskDecision;
import com.crivano.jflow.task.TaskEmail;
import com.crivano.jflow.task.TaskEval;
import com.crivano.jflow.task.TaskForm;

public enum WfTipoDeTarefa implements TaskKind {

	FORMULARIO("Formulário", "rectangle", TaskForm.class),
	//
	DECISAO("Decisão", "diamond", TaskDecision.class),
	//
	EXECUTAR("Executar", "rectangle", TaskEval.class),
	//
	EMAIL("Email", "folder", TaskEmail.class);

	private final String descr;

	private Class<? extends Task> clazz;

	private String graphKind;

	WfTipoDeTarefa(String descr, String graphKind, Class<? extends Task> clazz) {
		this.descr = descr;
		this.graphKind = graphKind;
		this.clazz = clazz;
	}

	@Override
	public String getDescr() {
		return this.descr;
	}

	@Override
	public Class<? extends Task> getClazz() {
		return this.clazz;
	}

	@Override
	public String getGraphKind() {
		return this.graphKind;
	}
}