#!/usr/bin/env python
'''
uBpref

@inproceedings{palotti2016,
    title={Ranking Health Web Pages with Relevance and Understandability},
    author={Joao Palotti, Lorraine Goeuriot, Guido Zuccon, Allan Hanbury},
    booktitle={Proceedings of the 39th International ACM SIGIR Conference on Research and Development in Information Retreival (SIGIR'16)},
    year={2016},
    organization={ACM}
}

usage: ubpref.py [-h] -q

'''

import argparse
import pandas as pd
import numpy as np

def go(run_file, qrels_file, qreads_file, all_queries):

    run = pd.read_csv(run_file, sep="\s", engine="python", names=["topic","qzero","filename","ranking","score","system"])
    qreads = pd.read_csv(qrels_file, sep="\s", engine="python", names=["topic","zero","filename","rel"])
    qrels = pd.read_csv(qreads_file, sep="\s", engine="python", names=["topic","zero","filename","read"])

    # Merge assessments into a single pandas dataframe
    assessments = pd.merge(qrels, qreads, on=["filename","topic","zero"])
    assessments["is_rel"] = assessments["rel"] > 0
    assessments["is_nrel"] = assessments["rel"] == 0

    # Merge run and assessments
    run_assessed = pd.merge(run, assessments, on=["filename","topic"], how="left")
    run_assessed.fillna(False, inplace=True)
    run_assessed.sort_values(by=["score","filename"], ascending=[False,False], inplace=True) # it is the same sorting that trec_eval does

    bprefs, ubprefs = [], []
    for topic in assessments.topic.unique():
        bpref, ubpref = get_prefs(run_assessed, assessments, topic)
        if all_queries:
            print "bpref\t%s\t%.4f\nubpref\t%s\t%.4f" % (str(topic), bpref,str(topic),ubpref)
        bprefs.append(bpref)
        ubprefs.append(ubpref)

    print "bpref\tall\t%.4f"  % (np.array(bprefs).mean())
    print "ubpref\tall\t%.4f"  % (np.array(ubprefs).mean())


def calc_bpref(relevant, nrelevant, total_relevant, total_non_relevant):
    nrelevant_so_far = 0
    bpref = 0
    for r, nr in zip(relevant,nrelevant):
	if r and nr:
	    print "ERROR!!!!!! This file cannot be relevant and non-relevant at the same time!"
	if not r and not nr:
	    # print "Not judgeded."
	    continue
	if r:
	    bpref += (1.0 - (1.0 * min(nrelevant_so_far,total_relevant) / min(total_relevant,total_non_relevant)))
	if nr:
	    nrelevant_so_far += 1

    if total_relevant > 0:
	bpref = bpref / total_relevant
    return bpref

def get_readability_map(read_level):
    read_score = [0.0, 0.4, 0.8, 1.0]
    return read_score[int(read_level)]

def calc_ubpref(relevant, nrelevant, total_relevant, total_non_relevant, readabilities):

    nrelevant_so_far = 0
    bpref = 0
    for r, nr, read_level in zip(relevant,nrelevant,readabilities):
        if r and nr:
            print "ERROR!!!!!! This file cannot be relevant and non-relevant at the same time!"
        if not r and not nr:
            # print "Not judgeded."
            continue
        if r:
            frac =  (1.0 - (1.0 * min(nrelevant_so_far,total_relevant) / min(total_relevant,total_non_relevant)))
            read_score = get_readability_map(read_level)

            #print "Read: %f, Frac %f, NewFrac %f, nrelevant_so_far %d, bpref: %f" % (read_score, frac, read_score * frac, nrelevant_so_far, bpref)
            bpref += (frac * read_score)
            # print "Frac %f, nrelevant_so_far %d, R: %d, N: %d, bpref: %f" % (frac, nrelevant_so_far, R, N, bpref)
        if nr:
            nrelevant_so_far += 1

    if total_relevant > 0:
        bpref = bpref / total_relevant
    return bpref

def get_prefs(run, assessments, topic):

    relevants = run[run["topic"] == topic]["is_rel"].values
    non_relevants = run[run["topic"] == topic]["is_nrel"].values
    assessment_topic = assessments[assessments["topic"] == topic]
    total_rel, total_non_rel = assessment_topic[["is_rel", "is_nrel"]].sum().values
    bpref = calc_bpref(relevants, non_relevants, total_rel, total_non_rel)

    readabilities = run[run["topic"] == topic]["read"].values
    ubpref = calc_ubpref(relevants, non_relevants, total_rel, total_non_rel, readabilities)
    return bpref, ubpref


if __name__ == "__main__":
    '''
    Main method: collection command line args and call bpref.
    '''

    arg_parser = argparse.ArgumentParser(description="UBref implementation.")
    arg_parser.add_argument("trec_qrel_file", help="TREC style qrel file.")
    arg_parser.add_argument("trec_qread_file", help="TREC style qread file - similar to qrel but with understandability assessments.")
    arg_parser.add_argument("trec_run_file", help="TREC style run file (a participating system)")
    arg_parser.add_argument('-q', dest='all_queries', default=False, action='store_const', const=True, help='In addition to summary evaluation, give evaluation for each query')

    args = arg_parser.parse_args()
    go(args.trec_run_file, args.trec_qrel_file, args.trec_qread_file, args.all_queries)

