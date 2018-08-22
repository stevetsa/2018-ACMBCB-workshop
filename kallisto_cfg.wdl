workflow kallisto {
  File fasta    
  File read1
  File read2

  call index {
    input:
      FASTA=fasta
  }

  call quant {
    input:
      INDEX = index.indexFASTA,
      READ1 = read1,
      READ2 = read2
  }
}

task index {
  File FASTA
  
  command <<<
    kallisto index -i transcript_index ${FASTA}
  >>>
  
  output {
    File indexFASTA = "transcript_index"
  }
}

task quant {
  File INDEX
  File READ1
  File READ2

  command <<<
    kallisto quant -o outputDir -i ${INDEX} ${READ1} ${READ2}
    tar -zcvf quant.tar.gz outputDir    
  >>>

  output {
    File TAR = "quant.tar.gz"
  }
}
