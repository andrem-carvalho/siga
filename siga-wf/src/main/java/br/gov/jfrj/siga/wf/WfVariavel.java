package br.gov.jfrj.siga.wf;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.SequenceGenerator;

import com.crivano.jflow.support.ProcessInstanceVariable;

public class WfVariavel implements ProcessInstanceVariable {
	@Id
	@Column(name = "VARI_ID", unique = true, nullable = false)
	private Long id;

	@Column(name = "VARI_NM", length = 256)
	private String nome;

	@Column(name = "VARI_TX")
	String string;

	@Column(name = "VARI_DF")
	Date date;

	@Column(name = "VARI_FG")
	Boolean bool;

	@Column(name = "VARI_NR")
	Double number;

	public String getNome() {
		return nome;
	}

	public void setNome(String nome) {
		this.nome = nome;
	}

	@Override
	public String getIdentifier() {
		return getNome();
	}

	@Override
	public void setIdentifier(String identifier) {
		this.setNome(identifier);
	}

	@Override
	public String getString() {
		return string;
	}

	@Override
	public void setString(String string) {
		this.string = string;
	}

	@Override
	public Date getDate() {
		return date;
	}

	@Override
	public void setDate(Date date) {
		this.date = date;
	}

	@Override
	public Boolean getBool() {
		return bool;
	}

	@Override
	public void setBool(Boolean bool) {
		this.bool = bool;
	}

	@Override
	public Double getNumber() {
		return number;
	}

	@Override
	public void setNumber(Double number) {
		this.number = number;
	}

}