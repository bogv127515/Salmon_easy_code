from os import stat
import numpy as np
from numpy.lib.function_base import corrcoef
from sklearn.metrics.pairwise import cosine_similarity
import pandas as pd
import scipy.stats
import math

def mtx_similar1(arr1:np.ndarray, arr2:np.ndarray) ->float:
    '''
    将np.array矩阵按行展开为一维数组，计算pearsonr相似性
    :param arr1:矩阵1
    :param arr2:矩阵2
    :return:相似度
    '''
    num = arr1.ravel()*arr2.ravel()
    denom = np.linalg.norm(arr1)*np.linalg.norm(arr2)
    similar = scipy.stats.pearsonr(arr1.ravel(), arr2.ravel())
    return similar

def mtx_similar2(arr1:np.ndarray, arr2:np.ndarray) ->float:
    '''
    同维度矩阵差值平方和与参照矩阵的平方和求余弦相似性
    :param arr1:矩阵1
    :param arr2:矩阵2
    :return:相似度
    '''
    differ = arr1 - arr2
    numera = np.sum(differ**2)
    denom = np.sum(arr1**arr2)
    similar = 1 - (numera / denom)
    return similar


def mtx_similar3(arr1:np.ndarray, arr2:np.ndarray) ->float:
    '''
    From CS231n: There are many ways to decide whether
    two matrices are similar; one of the simplest is the Frobenius norm. In case
    you haven't seen it before, the Frobenius norm of two matrices is the square
    root of the squared sum of differences of all elements; in other words, reshape
    the matrices into vectors and compute the Euclidean distance between them.
    difference = np.linalg.norm(dists - dists_one, ord='fro')
    :param arr1:矩阵1
    :param arr2:矩阵2
    :return:相似度（0~1之间）
    '''
    if arr1.shape != arr2.shape:
        minx = min(arr1.shape[0],arr2.shape[0])
        miny = min(arr1.shape[1],arr2.shape[1])
        differ = arr1[:minx,:miny] - arr2[:minx,:miny]
    else:
        differ = arr1 - arr2
    dist = np.linalg.norm(differ, ord='fro')
    len1 = np.linalg.norm(arr1)
    len2 = np.linalg.norm(arr2)     # 普通模长
    denom = (len1 + len2) / 2
    similar = 1 - (dist / denom)
    return similar

'''def test_similar():
    arr1 = np.array([[1,-2,3,7],[-8,2,5,9]])
    arr2 = np.array([[1, -2, 3, 7], [-8, 2, 6, 9]])
    arr3 = np.array([[-2, 3, 7], [2, 7, 9]])
    arr4 = np.array([[4, -2, 3], [-8, 2, 7]])
    print('similar arr1&2:', mtx_similar1(arr1, arr2),
          mtx_similar2(arr1, arr2), mtx_similar3(arr1, arr2), sep=' ')
    print('similar arr2&3:', mtx_similar1(arr2, arr3),
          mtx_similar2(arr2, arr3), mtx_similar3(arr2, arr3), sep=' ')
    print('similar arr2&4:', mtx_similar1(arr2, arr4),
          mtx_similar2(arr2, arr4), mtx_similar3(arr2, arr4), sep=' ')
    print('similar arr4&4:', mtx_similar1(arr4, arr4),
          mtx_similar2(arr4, arr4), mtx_similar3(arr4, arr4), sep=' ')'''

std_mtx = np.array(pd.read_csv("./std_sim.csv",index_col=0,header=1))
Salmon_mtx = np.array(pd.read_csv("./Salmon_sim.csv",index_col=0,header=1))
GEO_mtx = np.array(pd.read_csv("./Geo_sim.csv",index_col=0,header=1))
star_mtx = np.array(pd.read_csv("./STAR_sim.csv",index_col=0,header=1))

print("Salmon_easy VS GEO Similar1:",mtx_similar1(GEO_mtx,Salmon_mtx))
print("Salmon_easy VS GEO Similar2:",mtx_similar2(GEO_mtx,Salmon_mtx))
print("Salmon_easy VS GEO Similar3:",mtx_similar3(GEO_mtx,Salmon_mtx))
print("STAR VS GEO Similar1:",mtx_similar1(GEO_mtx,star_mtx))
print("STAR VS GEO Similar2:",mtx_similar2(GEO_mtx,star_mtx))
print("STAR VS GEO Similar3:",mtx_similar3(GEO_mtx,star_mtx))
print("Standard VS GEO Similar1:",mtx_similar1(GEO_mtx,std_mtx))
print("Standard VS GEO Similar2:",mtx_similar2(GEO_mtx,std_mtx))
print("Standard VS GEO Similar3:",mtx_similar3(GEO_mtx,std_mtx))